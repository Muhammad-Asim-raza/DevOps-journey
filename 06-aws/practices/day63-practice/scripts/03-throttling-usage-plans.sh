#!/bin/bash
# ================================================
# 03-throttling-usage-plans.sh
# Protect your backend from abuse and overload
# Author: Asim Raza - Day 63
# ================================================
source ../configs/api-config.sh 2>/dev/null || {
    API_ID="abc123demo"; REGION="us-east-1"
}

echo "============================================"
echo "   THROTTLING, USAGE PLANS, API KEYS"
echo "============================================"

echo ""
echo "[ WHY THROTTLE? ]"
echo "  One buggy client in a retry loop sends 10,000 req/s."
echo "  Without limits: Lambda scales up, DynamoDB/RDS melt,"
echo "  your AWS bill explodes."
echo "  Throttling returns 429 early and cheaply."

echo ""
echo "[ THROTTLING LEVELS ]"
echo "  1. Account level: about 10,000 req/s per region by default"
echo "     (soft limit, shared by ALL your APIs)"
echo "  2. Stage/route level: YOU set it"
echo "  3. (REST API) per-client level via usage plans"
echo ""
echo "  Two numbers:"
echo "  RATE  = steady requests per second allowed"
echo "  BURST = short spike capacity (token bucket size)"

echo ""
echo "[ HTTP API: per-route throttling ]"
echo "  aws apigatewayv2 update-stage \\"
echo "    --api-id $API_ID --stage-name prod \\"
echo "    --route-settings '{\"GET /status\":{\"ThrottlingRateLimit\":5,\"ThrottlingBurstLimit\":10}}'"
echo "  Expensive or sensitive routes get tighter limits."

echo ""
echo "[ REST API: USAGE PLANS + API KEYS ]"
echo "  HTTP APIs do NOT support these. Use a REST API for them."
echo ""
echo "  # 1. Usage plan (limits for a customer tier)"
echo "  PLAN_ID=\$(aws apigateway create-usage-plan \\"
echo "    --name gold-tier \\"
echo "    --throttle burstLimit=200,rateLimit=100 \\"
echo "    --quota limit=100000,period=MONTH \\"
echo "    --api-stages apiId=REST_API_ID,stage=prod \\"
echo "    --query id --output text)"
echo ""
echo "  # 2. API key (identifies a customer)"
echo "  KEY_ID=\$(aws apigateway create-api-key \\"
echo "    --name customer-acme --enabled \\"
echo "    --query id --output text)"
echo ""
echo "  # 3. Attach key to plan"
echo "  aws apigateway create-usage-plan-key \\"
echo "    --usage-plan-id \$PLAN_ID \\"
echo "    --key-id \$KEY_ID --key-type API_KEY"
echo ""
echo "  # 4. Client calls with header:"
echo "  curl -H 'x-api-key: THE_KEY' https://.../prod/health"
echo "  (method must have apiKeyRequired = true)"

echo ""
echo "[ ⚠️  API KEYS ARE NOT AUTHENTICATION ]"
echo "  They identify and meter a caller. They are easily leaked,"
echo "  have no expiry, and carry no identity or permissions."
echo "  Use them for QUOTAS. Use JWT/IAM/Lambda authorizers"
echo "  for SECURITY. Often you use both together."

echo ""
echo "[ WHAT CLIENTS SHOULD DO ON 429 ]"
echo "  Retry with exponential backoff + jitter:"
echo "  wait = min(cap, base * 2^attempt) * random(0.5, 1.5)"
echo "  Honour the Retry-After header if present."
echo "============================================"
