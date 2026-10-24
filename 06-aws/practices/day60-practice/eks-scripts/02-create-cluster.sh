#!/bin/bash
# ================================================
# 02-create-cluster.sh
# EKS Cluster Creation and kubectl Setup
# Author: Asim Raza - Day 60
# ================================================

echo 'set -euo pipefail'

echo 'REGION="${AWS_DEFAULT_REGION:-us-east-1}"'
echo 'CLUSTER_NAME="devops-journey"'

REGION='${AWS_DEFAULT_REGION:-us-east-1}'
CLUSTER_NAME='$CLUSTER_NAME'

echo "============================================"
echo "   EKS CLUSTER CREATION"
echo "   Author: Asim Raza - Day 60"
echo "============================================"

echo ""
echo "[ PRE-CREATION CHECKLIST ]"
echo ""
echo "  Before creating EKS cluster:"
echo "  ✅ AWS credentials configured"
echo "  ✅ eksctl installed (Lesson 1)"
echo "  ✅ kubectl installed"
echo "  ✅ IAM permissions (AdministratorAccess or EKS-specific)"
echo "  ✅ VPC planned (or let eksctl create one)"
echo "  ✅ K8s version chosen (1.29 or 1.30)"
echo ""
echo "  ⚠️  COST WARNING:"
echo "  EKS cluster: \$0.10/hour = \$73/month"
echo "  2× m5.large nodes: 2 × \$0.096 = \$0.192/hour"
echo "  Total minimum: ~\$0.29/hour = ~\$216/month"
echo "  DELETE when done learning!"

echo ""
echo "[ CREATING CLUSTER FROM CONFIG FILE ]"
echo ""
echo "  eksctl create cluster \\"
echo "    -f eks-configs/cluster-config.yaml \\"
echo "    --kubeconfig ~/.kube/devops-journey.yaml"
echo ""
echo "  Takes approximately 15-20 minutes"
echo "  Creates:"
echo "  - VPC with public and private subnets"
echo "  - Internet Gateway + NAT Gateways"
echo "  - EKS control plane"
echo "  - Managed node group (EC2 instances)"
echo "  - IAM roles and OIDC provider"
echo "  - All EKS add-ons"

echo ""
echo "[ QUICK CLUSTER FOR LEARNING (cheaper) ]"
echo ""
echo "  # Minimal cluster (1 node, t3.small):"
echo "  eksctl create cluster \\"
echo "    --name $CLUSTER_NAME \\"
echo "    --region $REGION \\"
echo "    --nodes 1 \\"
echo "    --node-type t3.small \\"
echo "    --managed \\"
echo "    --with-oidc \\"
echo "    --spot"
echo ""
echo "  # Cost: ~\$0.13/hour = ~\$97/month"
echo "  # ALWAYS delete after learning:"
echo "  eksctl delete cluster --name $CLUSTER_NAME"

echo ""
echo "[ CONFIGURE KUBECTL AFTER CREATION ]"
echo ""
echo "  # Update kubeconfig (adds cluster to ~/.kube/config):"
echo "  aws eks update-kubeconfig \\"
echo "    --name $CLUSTER_NAME \\"
echo "    --region $REGION"
echo ""
echo "  # Verify connection:"
echo "  kubectl get nodes"
echo "  kubectl get pods -A"
echo "  kubectl cluster-info"

echo 'if command -v kubectl &>/dev/null && \'
echo '   aws eks describe-cluster --name "$CLUSTER_NAME" \'
echo '   --region "$REGION" &>/dev/null 2>&1; then'
echo '    echo ""'
echo '    echo "[ LIVE CLUSTER STATUS ]"'
echo '    aws eks update-kubeconfig \'
echo '        --name "$CLUSTER_NAME" \'
echo '        --region "$REGION" 2>/dev/null || true'
echo '    kubectl get nodes 2>/dev/null || true'
echo '    kubectl get pods -A 2>/dev/null || true'
echo 'else'
echo '    echo ""'
echo '    echo "  (No cluster running - follow steps above to create)"'
echo 'fi'

echo ""
echo "[ KUBECONFIG MANAGEMENT ]"
echo ""
echo "  Multiple clusters = multiple kubeconfigs"
echo ""
echo "  # List contexts:"
echo "  kubectl config get-contexts"
echo ""
echo "  # Switch context:"
echo "  kubectl config use-context CONTEXT_NAME"
echo ""
echo "  # Set as current context:"
echo "  aws eks update-kubeconfig \\"
echo "    --name $CLUSTER_NAME \\"
echo "    --alias $CLUSTER_NAME"
echo ""
echo "  # View current context:"
echo "  kubectl config current-context"
echo ""
echo "  # Rename context:"
echo "  kubectl config rename-context \\"
echo "    arn:aws:eks:us-east-1:xxx:cluster/$CLUSTER_NAME \\"
echo "    $CLUSTER_NAME"
echo ""
echo "  ⚠️  Never run kubectl on wrong cluster!"
echo "  Always check: kubectl config current-context"
echo "  Before: kubectl delete, kubectl apply in production"

echo ""
echo "[ CHECK CLUSTER VERSION ]"
echo ""
echo "  # Check K8s version:"
echo "  kubectl version"
echo ""
echo "  # List available EKS versions:"
echo "  aws eks describe-addon-versions \\"
echo "    --query 'addons[0].addonVersions[*].compatibilities[*].clusterVersion' \\"
echo "    --output text | tr ' ' '\n' | sort -u"
echo ""
echo "  # Upgrade cluster (one version at a time!):"
echo "  eksctl upgrade cluster \\"
echo "    --name $CLUSTER_NAME \\"
echo "    --version 1.30 \\"
echo "    --approve"
echo "  # Then upgrade node groups"
echo "  # Then upgrade add-ons"
echo "  # Must go: 1.28 → 1.29 → 1.30 (no skipping!)"

echo ""
echo "============================================"
echo "   CLUSTER CREATION GUIDE COMPLETE"
echo "============================================"
