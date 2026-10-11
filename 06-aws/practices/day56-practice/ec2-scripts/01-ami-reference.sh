#!/bin/bash
# ================================================
# 01-ami-reference.sh
# AMI Reference and Search
# Author: Asim Raza - Day 56
# ================================================
set -euo pipefail

REGION="${AWS_DEFAULT_REGION:-us-east-1}"

echo "============================================"
echo "   AMI - AMAZON MACHINE IMAGES"
echo "   The template for your EC2 instance"
echo "============================================"

echo ""
echo "[ WHAT IS AN AMI? ]"
echo ""
echo "  AMI = snapshot of a configured server"
echo "  Contains:"
echo "  - Operating system (Ubuntu 22.04, Amazon Linux 2023)"
echo "  - Pre-installed software (LAMP stack, Docker, etc.)"
echo "  - Configuration files"
echo "  - EBS snapshot(s) for root and data volumes"
echo ""
echo "  Like a VM template or Docker image but for EC2"
echo "  Launch 1 instance or 1000 from same AMI"

echo ""
echo "[ AMI SOURCES ]"
echo ""
echo "  1. AWS Official AMIs:"
echo "     Amazon Linux 2023 (AWS optimized)"
echo "     Ubuntu 20.04, 22.04, 24.04 LTS"
echo "     Red Hat Enterprise Linux"
echo "     Windows Server 2019/2022"
echo ""
echo "  2. AWS Marketplace:"
echo "     Pre-configured software (CentOS, Kali, etc.)"
echo "     Paid AMIs (software license included)"
echo "     Common: Palo Alto, Sophos, F5 load balancer"
echo ""
echo "  3. Community AMIs:"
echo "     Public, shared by other users"
echo "     USE WITH CAUTION: not vetted by AWS"
echo ""
echo "  4. YOUR custom AMIs:"
echo "     Launch instance → configure → create AMI"
echo "     Fast launch: pre-baked dependencies"
echo "     Immutable infrastructure: same AMI everywhere"

echo ""
echo "[ FINDING AMIs WITH CLI ]"
echo ""
echo "  # Amazon Linux 2023 (latest):"
echo "  aws ec2 describe-images \\"
echo "    --owners amazon \\"
echo "    --filters \\"
echo "      'Name=name,Values=al2023-ami-2023.*-x86_64' \\"
echo "      'Name=state,Values=available' \\"
echo "    --query 'sort_by(Images, &CreationDate)[-1].ImageId' \\"
echo "    --output text \\"
echo "    --region $REGION"
echo ""

# Try to get actual AMI IDs
echo "  # Ubuntu 22.04 LTS (latest):"
echo "  aws ec2 describe-images \\"
echo "    --owners 099720109477 \\"
echo "    --filters \\"
echo "      'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*' \\"
echo "      'Name=state,Values=available' \\"
echo "    --query 'sort_by(Images, &CreationDate)[-1].ImageId' \\"
echo "    --output text"
echo ""
echo "  # Ubuntu 24.04 LTS (latest):"
echo "  aws ec2 describe-images \\"
echo "    --owners 099720109477 \\"
echo "    --filters \\"
echo "      'Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*' \\"
echo "      'Name=state,Values=available' \\"
echo "    --query 'sort_by(Images, &CreationDate)[-1].ImageId' \\"
echo "    --output text"
echo ""
echo "  # Common AWS Official Owner IDs:"
echo "  amazon (al2023, Amazon Linux 2)"
echo "  099720109477 (Canonical - Ubuntu)"
echo "  309956199498 (RedHat)"
echo "  125523088429 (CentOS)"

if command -v aws &>/dev/null; then
    echo ""
    echo "  [ Live: Latest Amazon Linux 2023 AMI ]"
    aws ec2 describe-images \
        --owners amazon \
        --filters \
            "Name=name,Values=al2023-ami-2023*x86_64" \
            "Name=state,Values=available" \
        --query 'sort_by(Images, &CreationDate)[-1].[ImageId,Name,CreationDate]' \
        --output table \
        --region "$REGION" 2>/dev/null || \
        echo "  (configure AWS credentials to see live data)"
fi

echo ""
echo "[ AMI KEY CONCEPTS ]"
echo ""
echo "  AMI ID format:  ami-0abcdef1234567890"
echo "  Region-specific: same AMI ID means different"
echo "                   OS in different regions!"
echo "  Always specify region when using AMI IDs"
echo ""
echo "  AMI Virtualization types:"
echo "  HVM (Hardware Virtual Machine) ← use this"
echo "  PV  (Paravirtual) ← legacy, avoid"
echo ""
echo "  Architecture:"
echo "  x86_64  (Intel/AMD) ← most common"
echo "  arm64   (Graviton)  ← cheaper, great performance"

echo ""
echo "[ CUSTOM AMI CREATION ]"
echo ""
echo "  1. Launch base instance (t3.micro)"
echo "  2. Connect via SSH"
echo "  3. Install and configure software:"
echo "     sudo yum install -y docker nginx python3"
echo "     sudo systemctl enable docker"
echo "  4. Create AMI from instance:"
echo "     aws ec2 create-image \\"
echo "       --instance-id i-0abc123 \\"
echo "       --name 'devops-platform-ami-v1' \\"
echo "       --description 'Pre-baked app server'"
echo "  5. AMI is now available to launch more instances"
echo "     aws ec2 describe-images --owners self"

echo ""
echo "============================================"
echo "   AMI REFERENCE COMPLETE"
echo "============================================"
