#!/bin/bash
# ================================================
# 03-irsa.sh
# IRSA - IAM Roles for Service Accounts
# The EKS equivalent of EC2 Instance Profiles
# Author: Asim Raza - Day 60
# ================================================

REGION="${AWS_DEFAULT_REGION:-us-east-1}"
CLUSTER_NAME="devops-journey"
ACCOUNT_ID="123456789012"

echo "============================================"
echo "   IRSA - IAM ROLES FOR SERVICE ACCOUNTS"
echo "   How pods get AWS permissions (securely)"
echo "   Author: Asim Raza - Day 60"
echo "============================================"

echo ""
echo "[ THE PROBLEM WITHOUT IRSA ]"
echo ""
echo "  Option 1: EC2 node IAM role (BAD)"
echo "  Node IAM role has S3 access"
echo "  ALL pods on that node can access S3"
echo "  Even pods that shouldn't!"
echo "  One compromised pod = all pods compromised"
echo ""
echo "  Option 2: Static credentials in pod (WORSE)"
echo "  env:"
echo "    - name: AWS_ACCESS_KEY_ID"
echo "      value: AKIAIOSFODNN7EXAMPLE"
echo "  Credentials in YAML = in Git = exposed"
echo ""
echo "  Option 3: IRSA (CORRECT)"
echo "  Each pod gets its OWN IAM role"
echo "  Pod A: only reads bucket-a"
echo "  Pod B: only writes to DynamoDB"
echo "  No sharing, no over-privilege"

echo ""
echo "[ HOW IRSA WORKS ]"
cat << 'DIAGRAM'

  OIDC Provider (cluster identity)
  URL: oidc.eks.us-east-1.amazonaws.com/id/CLUSTER-ID
         │
         │ issues token to pod
         ▼
  ┌─────────────────────────────────┐
  │  Pod running in EKS             │
  │  serviceAccountName: my-app-sa  │
  │                                 │
  │  env (auto-injected):           │
  │  AWS_ROLE_ARN: arn:...role/...  │
  │  AWS_WEB_IDENTITY_TOKEN_FILE    │
  │                                 │
  │  boto3/SDK: detects these       │
  │  calls sts:AssumeRoleWithWeb... │
  └─────────────────────────────────┘
         │
         │ exchanges OIDC token for
         │ temporary AWS credentials
         ▼
  ┌─────────────────────────────────┐
  │  AWS STS                        │
  │  Returns: AccessKey, SecretKey  │
  │  Expiry: 1 hour (auto-renew)   │
  └─────────────────────────────────┘
         │
         ▼
  ┌─────────────────────────────────┐
  │  IAM Role                       │
  │  Trust: oidc.eks.../sa/my-app   │
  │  Permissions: s3:GetObject      │
  │  on specific bucket only        │
  └─────────────────────────────────┘

DIAGRAM

echo ""
echo "[ SET UP IRSA FOR YOUR APPLICATION ]"
echo ""

echo "  STEP 1: Ensure OIDC provider exists"
echo "  eksctl utils associate-iam-oidc-provider \\"
echo "    --cluster $CLUSTER_NAME \\"
echo "    --region $REGION \\"
echo "    --approve"
echo ""

# Print OIDC provider URL command
echo "  aws eks describe-cluster \\"
echo "    --name \"$CLUSTER_NAME\" \\"
echo "    --query 'cluster.identity.oidc.issuer' \\"
echo "    --output text \\"
echo "    --region \"$REGION\""

OIDC_URL="oidc.eks.${REGION}.amazonaws.com/id/EXAMPLE"

echo "  OIDC Provider URL: $OIDC_URL"

echo ""
echo "  STEP 2: Create IAM trust policy for the role"

echo "  cat > ../eks-configs/irsa-trust-policy.json << EOF"

cat << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/${OIDC_URL}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_URL}:aud": "sts.amazonaws.com",
          "${OIDC_URL}:sub": "system:serviceaccount:production:devops-platform-sa"
        }
      }
    }
  ]
}
EOF

echo "EOF"

echo "  Trust policy saved: eks-configs/irsa-trust-policy.json"
echo ""
echo "  Condition breakdown:"
echo "  aud: sts.amazonaws.com (token audience)"
echo "  sub: system:serviceaccount:NAMESPACE:SA-NAME"
echo "       → ONLY this specific service account can assume role"
echo "       → Even other SAs in same cluster cannot!"

echo ""
echo "  STEP 3: Create the IAM role"
echo "  aws iam create-role \\"
echo "    --role-name devops-platform-irsa-role \\"
echo "    --assume-role-policy-document file://irsa-trust-policy.json"
echo ""

echo "  STEP 4: Attach permissions (least privilege)"

echo "  cat > ../eks-configs/irsa-permissions.json << EOF"

cat << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::devops-journey-artifacts",
        "arn:aws:s3:::devops-journey-artifacts/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": ["secretsmanager:GetSecretValue"],
      "Resource": "arn:aws:secretsmanager:${REGION}:${ACCOUNT_ID}:secret:prod/devops-platform/*"
    }
  ]
}
EOF

echo "EOF"

echo "  Permissions policy saved: eks-configs/irsa-permissions.json"

echo ""
echo "  STEP 5: Create Kubernetes Service Account"

echo "  cat > ../k8s-manifests/service-account.yaml << EOF"

cat << EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: devops-platform-sa
  namespace: production
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${ACCOUNT_ID}:role/devops-platform-irsa-role
    # This annotation is the IRSA link
    # EKS sees this → injects OIDC token into pod
    # Pod can then assume the IAM role
EOF

echo "EOF"

echo "  Service account manifest: k8s-manifests/service-account.yaml"

echo ""
echo "  STEP 6: Use in your Deployment"

echo "  cat >> ../k8s-manifests/service-account.yaml << 'SAEOF'"

cat << 'SAEOF'
---
# In your deployment:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-platform
  namespace: production
spec:
  template:
    spec:
      serviceAccountName: devops-platform-sa
      # This links the pod to the IAM role via IRSA!
      # No credentials needed in the pod
      # AWS SDK automatically uses OIDC token
      containers:
        - name: app
          image: IMAGE
          # boto3.client('s3') just works!
          # SDK finds OIDC token → calls STS
          # Gets temporary credentials
SAEOF

echo "SAEOF"

echo ""
echo "[ eksctl SHORTCUT FOR IRSA ]"
echo ""
echo "  eksctl can create IAM role + K8s SA in one command:"
echo ""
echo "  eksctl create iamserviceaccount \\"
echo "    --cluster $CLUSTER_NAME \\"
echo "    --namespace production \\"
echo "    --name devops-platform-sa \\"
echo "    --attach-policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess \\"
echo "    --approve \\"
echo "    --override-existing-serviceaccounts"
echo ""
echo "  Creates:"
echo "  - IAM role with trust policy pointing to cluster OIDC"
echo "  - K8s ServiceAccount with correct annotation"
echo "  - All in one command!"

echo ""
echo "[ VERIFY IRSA WORKING ]"
echo ""
echo "  # Check service account has annotation:"
echo "  kubectl describe serviceaccount devops-platform-sa \\"
echo "    -n production"
echo ""
echo "  # Check pod has OIDC token mounted:"
echo "  kubectl exec POD_NAME -n production -- \\"
echo "    env | grep AWS"
echo "  # Should see: AWS_ROLE_ARN and AWS_WEB_IDENTITY_TOKEN_FILE"
echo ""
echo "  # Test S3 access from pod:"
echo "  kubectl exec POD_NAME -n production -- \\"
echo "    aws s3 ls s3://devops-journey-artifacts/"

echo ""
echo "============================================"
echo "   IRSA SETUP GUIDE COMPLETE"
echo "============================================"
