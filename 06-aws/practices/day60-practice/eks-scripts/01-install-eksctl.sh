#!/bin/bash
# ================================================
# 01-install-eksctl.sh
# Install eksctl and create EKS cluster
# Author: Asim Raza - Day 60
# ================================================

echo 'set -euo pipefail'

echo 'REGION="${AWS_DEFAULT_REGION:-us-east-1}"'

echo "============================================"
echo "   EKSCTL - THE EKS CLI TOOL"
echo "   Author: Asim Raza - Day 60"
echo "============================================"

echo ""
echo "[ WHAT IS eksctl? ]"
echo ""
echo "  eksctl = official CLI tool for EKS"
echo "  Created by: Weaveworks (GitOps pioneers)"
echo "  Adopted by: AWS as official tool"
echo ""
echo "  Without eksctl: 15+ manual AWS CLI commands"
echo "    Create VPC, subnets, IGW, NAT GW"
echo "    Create IAM roles (10+ policies)"
echo "    Create EKS cluster"
echo "    Create node groups"
echo "    Configure kubeconfig"
echo "    Install add-ons"
echo "    = 2-3 hours of work"
echo ""
echo "  With eksctl:"
echo "  eksctl create cluster --name my-cluster"
echo "  = 15-20 minutes, everything done"

echo ""
echo "[ INSTALL eksctl ]"
echo ""

echo 'if ! command -v eksctl &>/dev/null; then'
echo '    echo "  Installing eksctl..."'
echo '    ARCH=$(uname -m)'
echo '    if [ "$ARCH" = "x86_64" ]; then'
echo '        PLATFORM="linux_amd64"'
echo '    elif [ "$ARCH" = "aarch64" ]; then'
echo '        PLATFORM="linux_arm64"'
echo '    else'
echo '        PLATFORM="linux_amd64"'
echo '    fi'

echo '    curl -sLo /tmp/eksctl.tar.gz \'
echo '        "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" \'
echo '        2>/dev/null || true'

echo '    if [ -f /tmp/eksctl.tar.gz ]; then'
echo '        tar -xzf /tmp/eksctl.tar.gz -C /tmp/'
echo '        sudo mv /tmp/eksctl /usr/local/bin/ 2>/dev/null || \'
echo '            mv /tmp/eksctl ~/bin/ 2>/dev/null || true'
echo '        echo "  ✅ eksctl installed"'
echo '    else'
echo '        echo "  Manual install:"'
echo '        echo "  curl -sLo eksctl.tar.gz \\"'
echo '        echo "    https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz"'
echo '        echo "  tar -xzf eksctl.tar.gz"'
echo '        echo "  sudo mv eksctl /usr/local/bin/"'
echo '    fi'
echo 'else'
echo '    echo "  ✅ eksctl already installed"'
echo 'fi'

echo 'eksctl version 2>/dev/null || echo "  (eksctl version check)"'

echo ""
echo "[ INSTALL kubectl (if not installed) ]"
echo ""

echo 'if ! command -v kubectl &>/dev/null; then'
echo '    echo "  Installing kubectl..."'
echo '    KUBECTL_VERSION=$(curl -s \'
echo '        https://dl.k8s.io/release/stable.txt \'
echo '        2>/dev/null || echo "v1.29.0")'
echo '    curl -sLo /tmp/kubectl \'
echo '        "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \'
echo '        2>/dev/null || true'
echo '    if [ -f /tmp/kubectl ]; then'
echo '        chmod +x /tmp/kubectl'
echo '        sudo mv /tmp/kubectl /usr/local/bin/ 2>/dev/null || \'
echo '            mv /tmp/kubectl ~/bin/ 2>/dev/null || true'
echo '        echo "  ✅ kubectl installed"'
echo '    fi'
echo 'else'
echo '    echo "  ✅ kubectl already installed"'
echo 'fi'

echo 'kubectl version --client 2>/dev/null || \'
echo '    echo "  (kubectl version check)"'

echo ""
echo "[ CLUSTER CREATION OPTIONS ]"
echo ""
echo "  Option 1: Quick cluster (dev/learning)"
echo "  eksctl create cluster \\"
echo "    --name devops-journey \\"
echo "    --region us-east-1 \\"
echo "    --nodes 2 \\"
echo "    --node-type t3.medium \\"
echo "    --managed"
echo "  Time: ~15 minutes"
echo "  Creates: VPC, subnets, nodes, everything"
echo ""
echo "  Option 2: Config file (production)"
echo "  eksctl create cluster -f cluster-config.yaml"
echo "  Full control over all settings"
echo "  Version controlled in Git"
echo ""
echo "  Option 3: Using existing VPC"
echo "  eksctl create cluster \\"
echo "    --vpc-private-subnets subnet-xxx,subnet-yyy \\"
echo "    --vpc-public-subnets subnet-aaa,subnet-bbb \\"
echo "    ..."
echo "  Use with your Day 55 VPC!"

echo ""
echo "[ CLUSTER LIFECYCLE COMMANDS ]"
echo ""
echo "  # Create:"
echo "  eksctl create cluster -f cluster.yaml"
echo ""
echo "  # Delete (EXPENSIVE if left running!):"
echo "  eksctl delete cluster --name devops-journey"
echo ""
echo "  # Get clusters:"
echo "  eksctl get cluster"
echo ""
echo "  # Update kubeconfig:"
echo "  aws eks update-kubeconfig \\"
echo "    --name devops-journey \\"
echo "    --region us-east-1"
echo ""
echo "  # Scale node group:"
echo "  eksctl scale nodegroup \\"
echo "    --cluster devops-journey \\"
echo "    --name ng-workers \\"
echo "    --nodes 5"
echo ""
echo "  # Upgrade cluster version:"
echo "  eksctl upgrade cluster \\"
echo "    --name devops-journey \\"
echo "    --version 1.30 \\"
echo "    --approve"

echo ""
echo "============================================"
echo "   EKSCTL SETUP COMPLETE"
echo "============================================"
