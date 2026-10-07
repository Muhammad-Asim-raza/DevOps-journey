#!/bin/bash
# ================================================
# 02-iam-setup-demo.sh
# IAM Setup Demonstration (dry-run)
# Author: Asim Raza - Day 54
# Shows what a proper IAM setup looks like
# ================================================

echo "============================================"
echo "   IAM SETUP DEMONSTRATION"
echo "   Production best practices"
echo "   Author: Asim Raza - Day 54"
echo "============================================"

# Configuration
ACCOUNT_ID=$(aws sts get-caller-identity \
    --query Account --output text 2>/dev/null || \
    echo "123456789012")
REGION="us-east-1"
APP_NAME="devops-platform"

echo ""
echo "Account ID: $ACCOUNT_ID"
echo "Region:     $REGION"
echo "App:        $APP_NAME"

echo ""
echo "[ STEP 1: Create Groups (not individual users) ]"
echo ""
echo "  Creating groups:"
echo "  aws iam create-group --group-name DevOpsEngineers"
echo "  aws iam create-group --group-name Developers"
echo "  aws iam create-group --group-name ReadOnly"
echo ""
echo "  Attach policies to groups:"
echo "  aws iam attach-group-policy \\"
echo "    --group-name DevOpsEngineers \\"
echo "    --policy-arn arn:aws:iam::aws:policy/PowerUserAccess"
echo ""
echo "  aws iam attach-group-policy \\"
echo "    --group-name Developers \\"
echo "    --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
echo ""
echo "  aws iam attach-group-policy \\"
echo "    --group-name ReadOnly \\"
echo "    --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess"
echo ""
echo "  ✅ Groups created and policies attached"

echo ""
echo "[ STEP 2: Create IAM User and add to group ]"
echo ""
echo "  aws iam create-user --user-name asim-raza"
echo ""
echo "  # Create login profile (console access):"
echo "  aws iam create-login-profile \\"
echo "    --user-name asim-raza \\"
echo "    --password 'TempP@ssw0rd!' \\"
echo "    --password-reset-required"
echo ""
echo "  # Add to group:"
echo "  aws iam add-user-to-group \\"
echo "    --user-name asim-raza \\"
echo "    --group-name DevOpsEngineers"
echo ""
echo "  # Create access key for CLI:"
echo "  aws iam create-access-key --user-name asim-raza"
echo "  → Save these keys securely!"
echo "  → NEVER in code, NEVER in Git"
echo ""
echo "  ✅ User created with group-based permissions"

echo ""
echo "[ STEP 3: Create EC2 Instance Role ]"
echo ""
cat << 'POLICY'
  # Trust policy (ec2-trust.json):
  {
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }

  # Create the role:
  aws iam create-role \
    --role-name devops-platform-ec2-role \
    --assume-role-policy-document file://ec2-trust.json

  # Attach permissions (principle of least privilege):
  aws iam attach-role-policy \
    --role-name devops-platform-ec2-role \
    --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

  # For reading SSM parameters:
  aws iam attach-role-policy \
    --role-name devops-platform-ec2-role \
    --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore

  # Create instance profile:
  aws iam create-instance-profile \
    --instance-profile-name devops-platform-profile

  aws iam add-role-to-instance-profile \
    --instance-profile-name devops-platform-profile \
    --role-name devops-platform-ec2-role
POLICY
echo ""
echo "  ✅ EC2 role created with minimal permissions"

echo ""
echo "[ STEP 4: GitHub Actions OIDC Role ]"
echo ""
cat << 'OIDC'
  # Create OIDC Provider (once per account):
  aws iam create-open-id-connect-provider \
    --url https://token.actions.githubusercontent.com \
    --client-id-list sts.amazonaws.com

  # Trust policy for GitHub Actions (github-trust.json):
  {
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub":
            "repo:Muhammad-Asim-raza/DevOps-journey:ref:refs/heads/main"
        }
      }
    }]
  }

  # Create CI/CD role:
  aws iam create-role \
    --role-name github-actions-devops-role \
    --assume-role-policy-document file://github-trust.json

  # Attach only what CI/CD needs:
  aws iam attach-role-policy \
    --role-name github-actions-devops-role \
    --policy-arn arn:aws:iam::aws:policy/AmazonECRContainerRegistryReadOnly
OIDC
echo ""
echo "  ✅ GitHub Actions can authenticate with OIDC"
echo "  ✅ No AWS keys stored anywhere!"

echo ""
echo "[ STEP 5: Verify with credential report ]"
echo ""
echo "  aws iam generate-credential-report"
echo "  aws iam get-credential-report \\"
echo "    --query Content --output text | base64 -d | column -t -s,"
echo ""
echo "  Check for:"
echo "  ✅ No users without MFA"
echo "  ✅ No stale access keys (>90 days unused)"
echo "  ✅ Root account has MFA enabled"
echo "  ✅ No root access keys exist"

echo ""
echo "============================================"
echo "   IAM SETUP DEMO COMPLETE"
echo "============================================"
