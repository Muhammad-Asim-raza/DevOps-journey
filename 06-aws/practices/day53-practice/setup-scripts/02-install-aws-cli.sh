#!/bin/bash
# ================================================
# 02-install-aws-cli.sh
# AWS CLI Installation and Configuration
# Author: Asim Raza - Day 53
# ================================================
set -euo pipefail

echo "============================================"
echo "   AWS CLI INSTALLATION"
echo "   The command-line interface for AWS"
echo "============================================"

echo ""
echo "[ What is AWS CLI? ]"
echo "  Command-line tool to interact with AWS"
echo "  Instead of clicking in the console:"
echo "  aws ec2 describe-instances"
echo "  aws s3 cp file.txt s3://my-bucket/"
echo "  aws rds describe-db-instances"
echo ""
echo "  Used in:"
echo "  - Scripts and automation"
echo "  - CI/CD pipelines (GitHub Actions!)"
echo "  - Infrastructure management"
echo "  - DevOps day-to-day work"

echo ""
echo "[ Installing AWS CLI v2 ]"
echo ""

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "  Detected: Linux"
    echo ""
    echo "  # Download AWS CLI v2:"
    echo '  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"'
    echo '  unzip awscliv2.zip'
    echo '  sudo ./aws/install'
    echo '  aws --version'
    echo ""

    # Actually install if not present
    if ! command -v aws &>/dev/null; then
        echo "  Installing AWS CLI..."
        curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
            -o "/tmp/awscliv2.zip" 2>/dev/null
        cd /tmp
        unzip -q awscliv2.zip 2>/dev/null
        sudo ./aws/install --update 2>/dev/null || true
        cd - > /dev/null
        echo "  ✅ AWS CLI installed"
    else
        echo "  ✅ AWS CLI already installed"
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  Detected: macOS"
    echo '  brew install awscli'
    echo '  # OR download from:'
    echo '  # https://awscli.amazonaws.com/AWSCLIV2.pkg'
fi

echo ""
echo "[ Verify installation ]"
aws --version 2>/dev/null || \
    echo "  AWS CLI not yet installed (follow steps above)"

echo ""
echo "[ AWS CLI Configuration ]"
echo ""
echo "  OPTION 1: aws configure (basic - for learning)"
echo "  aws configure"
echo "  AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE"
echo "  AWS Secret Access Key [None]: wJalrXUtnFEMI..."
echo "  Default region name [None]: us-east-1"
echo "  Default output format [None]: json"
echo ""
echo "  Where credentials are stored:"
echo "  ~/.aws/credentials"
echo "  ~/.aws/config"
echo ""
echo "  OPTION 2: Environment variables (for CI/CD)"
echo "  export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE"
echo "  export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI..."
echo "  export AWS_DEFAULT_REGION=us-east-1"
echo ""
echo "  OPTION 3: OIDC (best for GitHub Actions - Day 55)"
echo "  No stored credentials at all!"
echo "  IAM role trusted by GitHub OIDC"

echo ""
echo "[ AWS CLI Output Formats ]"
echo "  json    = JSON (default, machine-readable)"
echo "  text    = tab-separated (for shell scripts)"
echo "  table   = ASCII table (human-readable)"
echo "  yaml    = YAML format"
echo "  yaml-stream = YAML stream for large outputs"
echo ""
echo "  Override per command:"
echo "  aws ec2 describe-instances --output table"
echo "  aws s3 ls --output text"

echo ""
echo "[ Named Profiles (multiple accounts) ]"
echo ""
echo "  ~/.aws/credentials:"
echo "  [default]"
echo "  aws_access_key_id = KEY"
echo "  aws_secret_access_key = SECRET"
echo ""
echo "  [production]"
echo "  aws_access_key_id = PROD_KEY"
echo "  aws_secret_access_key = PROD_SECRET"
echo ""
echo "  [staging]"
echo "  aws_access_key_id = STAGING_KEY"
echo "  aws_secret_access_key = STAGING_SECRET"
echo ""
echo "  Use profile:"
echo "  aws s3 ls --profile production"
echo "  export AWS_PROFILE=staging"

echo ""
echo "============================================"
echo "   AWS CLI SETUP COMPLETE"
echo "============================================"
