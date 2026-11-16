#!/bin/bash
# ================================================
# 01-metrics.sh
# Read AWS metrics and publish custom metrics
# PRINT-ONLY VERSION
# Author: Asim Raza - Day 64
# ================================================

set -euo pipefail

REGION="${AWS_DEFAULT_REGION:-us-east-1}"

echo "============================================"
echo "       CLOUDWATCH METRICS"
echo "       PRINT ONLY MODE"
echo "============================================"

echo ""
echo "[ 1. LIST METRICS ]"

echo "aws cloudwatch list-metrics --namespace AWS/Lambda --region $REGION"

echo ""
echo "aws cloudwatch list-metrics --namespace AWS/EC2 --metric-name CPUUtilization --region $REGION"

echo ""
echo "[ 2. READ A METRIC ]"

echo "aws cloudwatch get-metric-statistics \\"
echo "  --namespace AWS/Lambda \\"
echo "  --metric-name Errors \\"
echo "  --dimensions Name=FunctionName,Value=devops-journey-api-handler \\"
echo "  --start-time \$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ) \\"
echo "  --end-time \$(date -u +%Y-%m-%dT%H:%M:%SZ) \\"
echo "  --period 300 \\"
echo "  --statistics Sum \\"
echo "  --region $REGION"

echo ""
echo "Explanation:"
echo "  --period 300 = one 5-minute period"
echo "  --statistics Sum = total errors during that period"
echo "  date commands above are also printed, not executed."

echo ""
echo "[ 3. GET METRIC DATA WITH METRIC MATH ]"

echo "aws cloudwatch get-metric-data \\"
echo "  --start-time 2026-08-21T00:00:00Z \\"
echo "  --end-time 2026-08-21T01:00:00Z \\"
echo "  --metric-data-queries '["

echo '    {"Id":"errors","MetricStat":{"Metric":{"Namespace":"AWS/Lambda",'
echo '      "MetricName":"Errors","Dimensions":[{"Name":"FunctionName",'
echo '      "Value":"devops-journey-api-handler"}]},"Period":300,"Stat":"Sum"},'
echo '      "ReturnData":false},'

echo '    {"Id":"invocations","MetricStat":{"Metric":{"Namespace":"AWS/Lambda",'
echo '      "MetricName":"Invocations","Dimensions":[{"Name":"FunctionName",'
echo '      "Value":"devops-journey-api-handler"}]},"Period":300,"Stat":"Sum"},'
echo '      "ReturnData":false},'

echo '    {"Id":"error_rate","Expression":"100*errors/invocations",'
echo '      "Label":"Error rate %"}'

echo "  ]'"

echo ""
echo "Metric math:"
echo "  Error rate = (Errors / Invocations) * 100"

echo ""
echo "[ 4. PUBLISH A CUSTOM METRIC ]"

echo "aws cloudwatch put-metric-data \\"
echo "  --namespace DevOpsJourney/App \\"
echo "  --metric-name OrdersProcessed \\"
echo "  --dimensions Environment=staging,Service=checkout \\"
echo "  --value 42 \\"
echo "  --unit Count \\"
echo "  --region $REGION"

echo ""
echo "NOTE: The custom metric command was NOT executed."

echo ""
echo "[ 5. IMPORTANT METRICS PER AWS SERVICE ]"

echo "Lambda:"
echo "  Errors, Throttles, Duration, ConcurrentExecutions"

echo ""
echo "API Gateway:"
echo "  4XXError, 5XXError, Latency, Count"

echo ""
echo "ALB:"
echo "  HTTPCode_Target_5XX_Count"
echo "  TargetResponseTime"
echo "  UnHealthyHostCount"

echo ""
echo "EC2:"
echo "  CPUUtilization"
echo "  StatusCheckFailed"
echo "  Memory and disk through CloudWatch Agent"

echo ""
echo "RDS:"
echo "  CPUUtilization"
echo "  FreeStorageSpace"
echo "  DatabaseConnections"
echo "  FreeableMemory"
echo "  ReplicaLag"
echo "  ReadLatency / WriteLatency"

echo ""
echo "ECS:"
echo "  CPUUtilization"
echo "  MemoryUtilization"

echo ""
echo "SQS:"
echo "  ApproximateAgeOfOldestMessage"
echo "  ApproximateNumberOfMessagesVisible"

echo ""
echo "[ 6. CUSTOM METRIC COST WARNING ]"

echo "Every unique custom metric identity can contribute to charges."
echo "Dimensions create separate metric identities."
echo "Avoid high-cardinality dimensions such as:"
echo "  UserId"
echo "  RequestId"
echo "  Full URLs"

echo ""
echo "Use LOGS for high-cardinality details."
echo "Use METRICS for aggregated numerical measurements."

echo ""
echo "============================================"
echo "       SCRIPT COMPLETED"
echo "       NO AWS COMMANDS EXECUTED"
echo "============================================"

