#!/bin/bash
# ================================================
# lambda-reference.sh
# Lambda Complete Reference
# Author: Asim Raza - Day 62
# ================================================

echo "============================================"
echo "   AWS LAMBDA COMPLETE REFERENCE"
echo "   Author: Asim Raza - Day 62"
echo "============================================"

echo ""
echo "[ WHAT IS LAMBDA ]"
echo "  Serverless = no servers to manage"
echo "  Pay per invocation + GB-second"
echo "  Idle: $0.00"
echo "  Max: 15 minutes, 10GB memory"
echo "  Scale: automatic (thousands concurrent)"

echo ""
echo "[ HANDLER ANATOMY ]"
echo "  def handler(event, context):"
echo "    event = trigger payload (dict)"
echo "    context.function_name, .aws_request_id"
echo "    context.get_remaining_time_in_millis()"
echo "    return JSON-serializable value"

echo ""
echo "[ COLD vs WARM ]"
echo "  Cold: download code + init runtime + run init code"
echo "  Warm: just run handler (fast!)"
echo "  Init outside handler = faster warm starts"

echo ""
echo "[ TRIGGERS ]"
echo "  Sync:    API Gateway, ALB"
echo "  Async:   S3, EventBridge, SNS → retries + DLQ"
echo "  Polling: SQS, Kinesis, DynamoDB Streams"

echo ""
echo "[ DEPLOYMENT ]"
echo "  aws lambda create-function \\"
echo "    --function-name NAME \\"
echo "    --runtime python3.11 \\"
echo "    --handler handler.handler \\"
echo "    --role ROLE_ARN \\"
echo "    --zip-file fileb://function.zip \\"
echo "    --timeout 30 \\"
echo "    --memory-size 512"
echo ""
echo "  aws lambda invoke \\"
echo "    --function-name NAME \\"
echo "    --payload '{\"key\":\"value\"}' \\"
echo "    --cli-binary-format raw-in-base64-out \\"
echo "    response.json"

echo ""
echo "[ CONCURRENCY ]"
echo "  Default: 1000 concurrent/account"
echo "  Reserved: protect downstream (DB!)"
echo "  Provisioned: keep warm (costs, no cold start)"
echo ""
echo "  aws lambda put-function-concurrency \\"
echo "    --function-name NAME \\"
echo "    --reserved-concurrent-executions 50"

echo ""
echo "[ KEY METRICS ]"
echo "  Invocations, Errors, Throttles"
echo "  Duration (p50, p95, p99)"
echo "  ConcurrentExecutions"
echo "  Alert on: Errors > 5, Throttles > 10"

echo ""
echo "============================================"
echo "   LAMBDA REFERENCE COMPLETE"
echo "============================================"
