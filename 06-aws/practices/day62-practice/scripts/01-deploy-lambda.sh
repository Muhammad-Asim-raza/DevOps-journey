#!/bin/bash
# ================================================
# 01-deploy-lambda.sh
# Deploy Lambda Functions
# Author: Asim Raza - Day 62
# ================================================
set -euo pipefail

REGION="${AWS_DEFAULT_REGION:-us-east-1}"
ACCOUNT_ID=$(aws sts get-caller-identity \
    --query Account --output text 2>/dev/null || \
    echo "123456789012")
APP_NAME="devops-journey"
FUNCTION_NAME="${APP_NAME}-hello-world"
LAMBDA_ROLE="arn:aws:iam::${ACCOUNT_ID}:role/${APP_NAME}-lambda-role"

echo "============================================"
echo "   DEPLOY LAMBDA FUNCTION"
echo "   Author: Asim Raza - Day 62"
echo "============================================"

# ── STEP 1: Create Lambda Execution Role ────────
echo ""
echo "[ STEP 1: Create Lambda Execution Role ]"
echo ""
echo "  Lambda execution role = what YOUR FUNCTION can do"
echo "  Different from: ECS execution role (infrastructure)"
echo "  Same concept as: ECS task role (application code)"
echo ""

cat > /tmp/lambda-trust-policy.json << 'EOF'
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }]
}
EOF

# Create role
aws iam create-role \
    --role-name "${APP_NAME}-lambda-role" \
    --assume-role-policy-document \
        file:///tmp/lambda-trust-policy.json \
    2>/dev/null && \
    echo "  ✅ Lambda execution role created" || \
    echo "  (Role may already exist)"

# Attach basic execution policy (write logs)
aws iam attach-role-policy \
    --role-name "${APP_NAME}-lambda-role" \
    --policy-arn \
        "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" \
    2>/dev/null && \
    echo "  ✅ AWSLambdaBasicExecutionRole attached" || true

# Optional: add X-Ray tracing
aws iam attach-role-policy \
    --role-name "${APP_NAME}-lambda-role" \
    --policy-arn \
        "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess" \
    2>/dev/null || true

echo ""
echo "  Policies attached:"
echo "  AWSLambdaBasicExecutionRole: write CloudWatch Logs"
echo "  AWSXRayDaemonWriteAccess:   send X-Ray traces"
echo ""
echo "  For S3 access: add custom policy"
echo "  For DynamoDB: add custom policy"
echo "  Always: least privilege per function!"

# ── STEP 2: Package Function ─────────────────────
echo ""
echo "[ STEP 2: Package Lambda Function ]"
echo ""

PACKAGE_DIR="/tmp/lambda-package-$$"
mkdir -p "$PACKAGE_DIR"

# Copy handler
cp lambda-functions/hello-world/handler.py \
    "$PACKAGE_DIR/"

# Install dependencies (if any)
REQUIREMENTS="lambda-functions/hello-world/requirements.txt"
if [ -f "$REQUIREMENTS" ]; then
    pip install -r "$REQUIREMENTS" \
        -t "$PACKAGE_DIR/" \
        --quiet 2>/dev/null
    echo "  ✅ Dependencies installed"
fi

# Create ZIP
cd "$PACKAGE_DIR"
zip -r /tmp/hello-world.zip . -q
cd - > /dev/null

echo "  ✅ Package created: /tmp/hello-world.zip"
echo "  Size: $(du -sh /tmp/hello-world.zip | cut -f1)"

echo ""
echo "  Package limits:"
echo "  ZIP (direct): 50MB compressed"
echo "  ZIP (S3):     250MB uncompressed"
echo "  Container:    10GB (ECR image)"
echo "  For large ML/data: use Lambda Layers or Container"

# ── STEP 3: Create / Update Function ────────────
echo ""
echo "[ STEP 3: Create Lambda Function ]"
echo ""

# Check if function exists
EXISTS=$(aws lambda get-function \
    --function-name "$FUNCTION_NAME" \
    --region "$REGION" \
    --query 'Configuration.FunctionName' \
    --output text 2>/dev/null) || EXISTS=""

if [ -z "$EXISTS" ] || [ "$EXISTS" = "None" ]; then
    echo "  Creating new function: $FUNCTION_NAME"

    aws lambda create-function \
        --function-name "$FUNCTION_NAME" \
        --runtime python3.11 \
        --role "$LAMBDA_ROLE" \
        --handler handler.handler \
        --zip-file fileb:///tmp/hello-world.zip \
        --timeout 30 \
        --memory-size 512 \
        --environment Variables='{
            ENVIRONMENT=development,
            LOG_LEVEL=INFO,
            BUCKET_NAME=devops-journey-artifacts
        }' \
        --tracing-config Mode=Active \
        --tags Project=devops-journey,Day=62 \
        --description "Day 62 - Lambda fundamentals" \
        --region "$REGION" 2>/dev/null && \
        echo "  ✅ Function created: $FUNCTION_NAME" || \
        echo "  (Configure credentials to create function)"
else
    echo "  Updating existing function: $FUNCTION_NAME"

    aws lambda update-function-code \
        --function-name "$FUNCTION_NAME" \
        --zip-file fileb:///tmp/hello-world.zip \
        --region "$REGION" 2>/dev/null && \
        echo "  ✅ Function code updated" || \
        echo "  (Configure credentials to update)"

    aws lambda update-function-configuration \
        --function-name "$FUNCTION_NAME" \
        --timeout 30 \
        --memory-size 512 \
        --region "$REGION" 2>/dev/null || true
fi

echo ""
echo "  Configuration explained:"
echo "  --runtime python3.11:    Python 3.11 runtime"
echo "  --handler handler.handler: file.function name"
echo "  --timeout 30:            max 15 minutes (900s)"
echo "  --memory-size 512:       MB (128-10240)"
echo "  --tracing-config Active: X-Ray distributed tracing"

# ── STEP 4: Invoke Function ──────────────────────
echo ""
echo "[ STEP 4: Test Invoke Function ]"
echo ""

# Wait for function to be active
sleep 3

aws lambda invoke \
    --function-name "$FUNCTION_NAME" \
    --payload '{"name": "Asim Raza"}' \
    --cli-binary-format raw-in-base64-out \
    /tmp/lambda-response.json \
    --region "$REGION" 2>/dev/null && \
    echo "  Response:" && \
    cat /tmp/lambda-response.json | \
    python3 -m json.tool 2>/dev/null || \
    echo "  (Configure credentials to invoke)"

echo ""
echo "  Invocation types:"
echo "  RequestResponse (default): synchronous, waits for response"
echo "  Event:                     asynchronous, returns immediately"
echo "  DryRun:                    validates permissions only"
echo ""
echo "  aws lambda invoke \\"
echo "    --function-name FUNCTION \\"
echo "    --invocation-type Event \\"
echo "    --payload '{\"key\": \"value\"}' \\"
echo "    response.json"

echo ""
echo "[ STEP 5: Lambda Versions and Aliases ]"
echo ""
echo "  Lambda versions: immutable snapshots"
echo ""
echo "  # Publish a version:"
echo "  aws lambda publish-version \\"
echo "    --function-name $FUNCTION_NAME \\"
echo "    --description 'v1.0.0 release'"
echo ""
echo "  # Create alias pointing to version:"
echo "  aws lambda create-alias \\"
echo "    --function-name $FUNCTION_NAME \\"
echo "    --name production \\"
echo "    --function-version 1"
echo ""
echo "  # Canary: alias splits traffic between versions:"
echo "  aws lambda update-alias \\"
echo "    --function-name $FUNCTION_NAME \\"
echo "    --name production \\"
echo "    --function-version 2 \\"
echo "    --routing-config AdditionalVersionWeights={\"1\"=0.9}"
echo "  # 90% → version 1 (stable)"
echo "  # 10% → version 2 (canary)"

# Cleanup
rm -rf "$PACKAGE_DIR"

echo ""
echo "============================================"
echo "   LAMBDA DEPLOYMENT COMPLETE"
echo "   Function: $FUNCTION_NAME"
echo "============================================"
