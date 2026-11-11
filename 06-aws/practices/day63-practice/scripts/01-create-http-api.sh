#!/bin/bash
# ================================================
# 01-create-http-api.sh
# Create HTTP API -> Lambda (step by step)
# Author: Asim Raza - Day 63
# ================================================
set -euo pipefail

REGION="${AWS_DEFAULT_REGION:-us-east-1}"
ACCOUNT_ID="123456789012"
APP_NAME="devops-journey"
API_NAME="${APP_NAME}-http-api"
FUNCTION_NAME="${APP_NAME}-api-handler"   # Day 62 function
FUNCTION_ARN="arn:aws:lambda:${REGION}:${ACCOUNT_ID}:function:${FUNCTION_NAME}"

echo "============================================"
echo "   CREATE HTTP API -> LAMBDA"
echo "   Author: Asim Raza - Day 63"
echo "============================================"

# STEP 1: Create the API
echo ""
echo "[ STEP 1: Create the API ]"
echo "  --protocol-type HTTP selects the cheaper, faster HTTP API"
echo "  --cors-configuration lets browsers call it from your frontend"

echo "aws apigatewayv2 create-api \
    --name \"$API_NAME\" \
    --protocol-type HTTP \
    --cors-configuration \
        AllowOrigins=\"https://app.example.com\",AllowMethods=\"GET,POST,OPTIONS\",AllowHeaders=\"content-type,authorization\",MaxAge=3600 \
    --tags Project=devops-journey,Day=63 \
    --query ApiId --output text \
    --region \"$REGION\""

API_ID="abc123demo"
echo "  API ID: $API_ID"

# STEP 2: Integration
echo ""
echo "[ STEP 2: Create the Lambda integration ]"
echo "  AWS_PROXY = pass the whole request to Lambda untouched"
echo "  payload-format-version 2.0 = the newer, simpler event shape"

echo "aws apigatewayv2 create-integration \
    --api-id \"$API_ID\" \
    --integration-type AWS_PROXY \
    --integration-uri \"$FUNCTION_ARN\" \
    --payload-format-version 2.0 \
    --query IntegrationId --output text \
    --region \"$REGION\""

INTEGRATION_ID="int123demo"
echo "  Integration ID: $INTEGRATION_ID"

# STEP 3: Routes
echo ""
echo "[ STEP 3: Create routes ]"
echo "  A route = METHOD + PATH -> integration"

for ROUTE in "GET /" "GET /health" "GET /build" "GET /status"; do
    echo "aws apigatewayv2 create-route \
        --api-id \"$API_ID\" \
        --route-key \"$ROUTE\" \
        --target \"integrations/${INTEGRATION_ID}\" \
        --region \"$REGION\""
    echo "  (would create route: $ROUTE)"
done

# STEP 4: Permission (the step everyone forgets)
echo ""
echo "[ STEP 4: Allow API Gateway to invoke the Lambda ]"
echo "  Without this you get 500/502 errors even though the"
echo "  route and integration look perfect."

echo "aws lambda add-permission \
    --function-name \"$FUNCTION_NAME\" \
    --statement-id \"apigw-invoke-${API_ID}\" \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com \
    --source-arn \"arn:aws:execute-api:${REGION}:${ACCOUNT_ID}:${API_ID}/*/*\" \
    --region \"$REGION\""

echo "  (would add invoke permission)"
echo "  source-arn restricts this to THIS API only (least privilege)"

# STEP 5: Stage with throttling
echo ""
echo "[ STEP 5: Create stage with throttling ]"
echo "  --auto-deploy: every change goes live automatically"
echo "  (REST APIs need an explicit deployment instead)"

echo "aws apigatewayv2 create-stage \
    --api-id \"$API_ID\" \
    --stage-name prod \
    --auto-deploy \
    --default-route-settings \
        ThrottlingBurstLimit=100,ThrottlingRateLimit=50 \
    --region \"$REGION\""

echo "  (would create stage)"

INVOKE_URL="https://${API_ID}.execute-api.${REGION}.amazonaws.com/prod"

echo ""
echo "[ YOUR API URL ]"
echo "  $INVOKE_URL"
echo "  curl $INVOKE_URL/health"

echo "echo \"API_ID=${API_ID}\"        >  ../configs/api-config.sh"
echo "echo \"REGION=${REGION}\"        >> ../configs/api-config.sh"
echo "echo \"INVOKE_URL=${INVOKE_URL}\" >> ../configs/api-config.sh"

echo ""
echo "[ CLEANUP ]"
echo "  aws apigatewayv2 delete-api --api-id $API_ID"

echo "============================================"
echo "   HTTP API CREATION COMPLETE"
echo "============================================"
