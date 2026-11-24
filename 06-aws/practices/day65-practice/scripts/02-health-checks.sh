#!/bin/bash
# ================================================
# 02-health-checks.sh
# Route 53 health checks + CloudWatch alarm
# Author: Asim Raza - Day 65
# ================================================
echo "============================================"
echo "   ROUTE 53 HEALTH CHECKS"
echo "============================================"

echo ""
echo "[ THREE TYPES ]"
echo "  1. Endpoint        probes an IP/domain over HTTP/HTTPS/TCP"
echo "  2. Calculated      combines other health checks (AND/OR/N of M)"
echo "  3. CloudWatch alarm health follows an alarm state"
echo "                     (use for PRIVATE resources: Route 53 checkers"
echo "                      live on the internet and can't reach your VPC)"

echo ""
echo "[ CREATE AN ENDPOINT HEALTH CHECK ]"
cat > ../configs/health-check.json << 'EOF'
{
  "Type": "HTTPS",
  "FullyQualifiedDomainName": "api.yourdomain.example",
  "Port": 443,
  "ResourcePath": "/health",
  "RequestInterval": 30,
  "FailureThreshold": 3,
  "MeasureLatency": true,
  "EnableSNI": true
}
EOF
echo "  aws route53 create-health-check \\"
echo "    --caller-reference hc-\$(date +%s) \\"
echo "    --health-check-config file://../configs/health-check.json"
aws route53 create-health-check --caller-reference "hc-$(date +%s)" \
    --health-check-config file://../configs/health-check.json \
    --query 'HealthCheck.Id' --output text 2>/dev/null || \
    echo "  (would create; needs a reachable endpoint)"

echo ""
echo "  RequestInterval 30 s, FailureThreshold 3 -> marked unhealthy"
echo "  after roughly 90 s of failures. Fast interval (10 s) costs more."
echo "  Checkers run from several regions; ~18% must report healthy."
echo "  /health should be CHEAP and meaningful (Day 52 pattern:"
echo "  /health liveness vs /ready dependencies)."

echo ""
echo "[ ⚠️  FIREWALLS ]"
echo "  Your security group must allow Route 53 health checker IP"
echo "  ranges:  aws route53 get-checker-ip-ranges"
echo "  Common bug: SG blocks them, check says 'unhealthy', failover"
echo "  triggers needlessly."

echo ""
echo "[ ALARM ON HEALTH CHECK STATUS (links to Day 64) ]"
echo "  Metric: AWS/Route53  HealthCheckStatus  (1=healthy, 0=unhealthy)"
echo "  IMPORTANT: Route 53 metrics exist ONLY in us-east-1, so create"
echo "  the alarm and its SNS topic in us-east-1."
echo ""
echo "  aws cloudwatch put-metric-alarm --region us-east-1 \\"
echo "    --alarm-name api-endpoint-down \\"
echo "    --namespace AWS/Route53 --metric-name HealthCheckStatus \\"
echo "    --dimensions Name=HealthCheckId,Value=HC_ID \\"
echo "    --statistic Minimum --period 60 --evaluation-periods 1 \\"
echo "    --threshold 1 --comparison-operator LessThanThreshold \\"
echo "    --alarm-actions arn:aws:sns:us-east-1:ACCOUNT:devops-journey-alerts"

echo ""
echo "[ ALIAS RECORDS: EvaluateTargetHealth ]"
echo "  Alias to an ALB with EvaluateTargetHealth=true makes Route 53"
echo "  treat the record as unhealthy if the ALB has no healthy targets,"
echo "  with no separate health check needed."
echo "============================================"
