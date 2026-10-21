#!/bin/bash
# ================================================
# 01-ecr-setup.sh
# ECR - Elastic Container Registry
# Push your Day 52 CI/CD project image to ECR
# Author: Asim Raza - Day 59
# ================================================
set -euo pipefail

REGION="${AWS_DEFAULT_REGION:-us-east-1}"
ACCOUNT_ID=$(aws sts get-caller-identity \
    --query Account --output text 2>/dev/null || \
    echo "123456789012")
APP_NAME="devops-cicd-platform"
REPO_NAME="${APP_NAME}"
ECR_URI="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"
IMAGE_URI="${ECR_URI}/${REPO_NAME}"

echo "============================================"
echo "   ECR - ELASTIC CONTAINER REGISTRY"
echo "   Your private Docker registry on AWS"
echo "   Author: Asim Raza - Day 59"
echo "============================================"
echo ""
echo "  Account:  $ACCOUNT_ID"
echo "  Region:   $REGION"
echo "  ECR URI:  $ECR_URI"
echo "  Image:    $IMAGE_URI"

echo ""
echo "[ WHY ECR OVER DOCKER HUB? ]"
echo ""
echo "  Docker Hub:"
echo "  ✗ Rate limits (100 pulls/6hr unauthenticated)"
echo "  ✗ Public by default (extra config for private)"
echo "  ✗ Separate credentials to manage"
echo "  ✗ No native IAM integration"
echo ""
echo "  ECR:"
echo "  ✅ IAM-controlled access (same as all AWS)"
echo "  ✅ No pull rate limits (within AWS network)"
echo "  ✅ Private by default"
echo "  ✅ Same-region pulls: FREE (no data transfer)"
echo "  ✅ Image scanning (Trivy-powered, built-in)"
echo "  ✅ Lifecycle policies (auto-delete old images)"
echo "  ✅ Immutable tags (prevent overwrite)"
echo "  Cost: \$0.10/GB/month after first 500MB free"

# ── CREATE ECR REPOSITORY ────────────────────────
echo ""
echo "[ STEP 1: Create ECR Repository ]"
echo ""

echo "aws ecr create-repository \
    --repository-name \"$REPO_NAME\" \
    --image-scanning-configuration scanOnPush=true \
    --image-tag-mutability IMMUTABLE \
    --encryption-configuration encryptionType=AES256 \
    --tags Key=Name,Value=\"$REPO_NAME\" \
           Key=Project,Value=\"devops-journey\" \
    --region \"$REGION\""

echo "  (Print only - ECR repository not created)"

echo ""
echo "  Settings explained:"
echo "  scanOnPush=true:       scan every pushed image"
echo "  IMMUTABLE tags:        sha-abc123 cannot be overwritten"
echo "  AES256 encryption:     at-rest encryption"
echo ""
echo "  ⚠️  IMMUTABLE is best practice:"
echo "  Without: overwrite sha-abc123 with different image"
echo "  With:    sha-abc123 ALWAYS = same image (safe)"

# ── ECR LIFECYCLE POLICY ─────────────────────────
echo ""
echo "[ STEP 2: Set Lifecycle Policy ]"
echo ""
echo "  Auto-delete old images to save storage cost"
echo ""

cat > ../ecs-configs/ecr-lifecycle.json << 'EOF'
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 tagged releases",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v"],
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Keep last 20 SHA-tagged images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["sha-"],
        "countType": "imageCountMoreThan",
        "countNumber": 20
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 3,
      "description": "Delete untagged images after 1 day",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF

echo "aws ecr put-lifecycle-policy \
    --repository-name \"$REPO_NAME\" \
    --lifecycle-policy-text \
        file://../ecs-configs/ecr-lifecycle.json \
    --region \"$REGION\""

echo "  (Print only - lifecycle policy not applied)"

# ── AUTHENTICATE AND PUSH ────────────────────────
echo ""
echo "[ STEP 3: Authenticate Docker to ECR ]"
echo ""
echo "  ECR login (token valid for 12 hours):"
echo "  aws ecr get-login-password --region $REGION | \\"
echo "    docker login \\"
echo "    --username AWS \\"
echo "    --password-stdin \\"
echo "    $ECR_URI"
echo ""

if command -v docker &>/dev/null && \
   command -v aws &>/dev/null; then

    echo "aws ecr get-login-password \
        --region \"$REGION\" | \
        docker login \
            --username AWS \
            --password-stdin \
            \"$ECR_URI\""

    echo "  (Print only - Docker not authenticated)"
fi

echo ""
echo "[ STEP 4: Build and Push Image ]"
echo ""
echo "  # Build your Day 52 project image:"
echo "  cd ~/DevOps-journey/05-cicd/project/devops-cicd-platform"
echo "  docker build \\"
echo "    --build-arg APP_VERSION=1.0.59 \\"
echo "    --build-arg GIT_COMMIT=\$(git rev-parse --short HEAD) \\"
echo "    -t ${IMAGE_URI}:sha-\$(git rev-parse --short HEAD) \\"
echo "    -t ${IMAGE_URI}:latest \\"
echo "    -f app/Dockerfile \\"
echo "    ."
echo ""
echo "  # Push to ECR:"
echo "  docker push ${IMAGE_URI}:sha-\$(git rev-parse --short HEAD)"
echo "  docker push ${IMAGE_URI}:latest"
echo ""

# Build actual image if Docker available
if command -v docker &>/dev/null; then
    APP_DIR="$HOME/DevOps-journey/05-cicd/project/devops-cicd-platform"
    if [ -d "$APP_DIR" ]; then
        SHORT_SHA=$(git -C "$HOME/DevOps-journey" \
            rev-parse --short HEAD 2>/dev/null || echo "demo123")
        IMAGE_TAG="${IMAGE_URI}:sha-${SHORT_SHA}"
        LOCAL_TAG="${APP_NAME}:sha-${SHORT_SHA}"

        echo "  Building: $LOCAL_TAG"

        echo "docker build \
            --build-arg APP_VERSION=\"1.0.59\" \
            --build-arg GIT_COMMIT=\"$SHORT_SHA\" \
            -t \"$LOCAL_TAG\" \
            -t \"${APP_NAME}:latest\" \
            -f \"$APP_DIR/app/Dockerfile\" \
            \"$APP_DIR\""

        echo "  (Print only - Docker image not built)"

        echo ""
        echo "  Tag for ECR:"

        echo "docker tag \"$LOCAL_TAG\" \"$IMAGE_TAG\""

        echo "  (Print only - Docker image not tagged)"

        echo ""
        echo "  Push to ECR:"
        echo "  docker push $IMAGE_TAG"
        echo "  (Skipping actual push in demo)"
    fi
fi

echo ""
echo "[ ECR CLI REFERENCE ]"
echo ""
echo "  # List repositories:"
echo "  aws ecr describe-repositories"
echo ""
echo "  # List images in repo:"
echo "  aws ecr list-images \\"
echo "    --repository-name $REPO_NAME \\"
echo "    --filter tagStatus=TAGGED"
echo ""
echo "  # Get image scan results:"
echo "  aws ecr describe-image-scan-findings \\"
echo "    --repository-name $REPO_NAME \\"
echo "    --image-id imageTag=latest"
echo ""
echo "  # Delete specific image:"
echo "  aws ecr batch-delete-image \\"
echo "    --repository-name $REPO_NAME \\"
echo "    --image-ids imageTag=sha-abc123"
echo ""
echo "  # Delete repository (including all images):"
echo "  aws ecr delete-repository \\"
echo "    --repository-name $REPO_NAME \\"
echo "    --force"

# Save config
cat > ../ecs-configs/ecr-config.sh << CONFIG
ACCOUNT_ID="${ACCOUNT_ID}"
REGION="${REGION}"
REPO_NAME="${REPO_NAME}"
ECR_URI="${ECR_URI}"
IMAGE_URI="${IMAGE_URI}"
CONFIG

echo ""
echo "============================================"
echo "   ECR SETUP COMPLETE"
echo "   Repository: $IMAGE_URI"
echo "============================================"
