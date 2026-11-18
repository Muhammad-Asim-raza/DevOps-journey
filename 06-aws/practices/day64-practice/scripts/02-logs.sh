#!/bin/bash
# ================================================
# 02-logs.sh
# CloudWatch Logs, retention, Insights, metric filters
# Author: Asim Raza - Day 64
# ================================================
REGION="${AWS_DEFAULT_REGION:-us-east-1}"
LOG_GROUP="/aws/lambda/devops-journey-api-handler"

echo "============================================"
echo "   CLOUDWATCH LOGS"
echo "============================================"

echo ""
echo "[ STRUCTURE ]"
echo "  Log GROUP   = one app/function (retention + access set here)"
echo "  Log STREAM  = one source instance (one container/Lambda env)"
echo "  Log EVENT   = one line with a timestamp"

echo ""
echo "[ ⚠️  SET RETENTION ON EVERY LOG GROUP ]"
echo "  Default is NEVER EXPIRE. Logs are billed for ingestion AND"
echo "  storage forever. Always set retention:"
echo "  aws logs put-retention-policy \\"
echo "    --log-group-name $LOG_GROUP --retention-in-days 30"
aws logs put-retention-policy --log-group-name "$LOG_GROUP" \
    --retention-in-days 30 --region "$REGION" 2>/dev/null && \
    echo "  ✅ 30-day retention set" || echo "  (would set retention)"
echo "  Typical: dev 7-14, prod 30-90, compliance 365+"
echo "  Archive to S3 (Day 57 lifecycle!) for cheap long-term."

echo ""
echo "[ TAILING AND FILTERING ]"
echo "  aws logs tail $LOG_GROUP --follow"
echo "  aws logs tail $LOG_GROUP --since 15m --filter-pattern ERROR"
echo "  aws logs filter-log-events --log-group-name $LOG_GROUP \\"
echo "    --filter-pattern '{ \$.statusCode = 500 }'"
echo ""
echo "  Filter pattern basics:"
echo "    ERROR                    term match"
echo "    ?ERROR ?WARN             either term"
echo "    \"connection refused\"     exact phrase"
echo "    { \$.level = \"ERROR\" }    JSON field match"

echo ""
echo "[ LOGS INSIGHTS: query language ]"
echo "  Console: CloudWatch > Logs Insights, pick log groups,"
echo "  pick time range, run a query. CLI:"
echo "  aws logs start-query ... ; aws logs get-query-results ..."
echo ""
echo "  Query 1: recent errors"
cat << 'Q'
    fields @timestamp, @message
    | filter @message like /ERROR/
    | sort @timestamp desc
    | limit 20
Q
echo "  Query 2: Lambda p95 duration per 5 min"
cat << 'Q'
    filter @type = "REPORT"
    | stats avg(@duration), pct(@duration, 95), max(@duration)
        by bin(5m)
Q
echo "  Query 3: cold starts"
cat << 'Q'
    filter @type = "REPORT" and ispresent(@initDuration)
    | stats count() as coldStarts, avg(@initDuration)
        by bin(1h)
Q
echo "  Query 4: API GW access logs (Day 63 JSON format): slowest routes"
cat << 'Q'
    stats count() as hits, avg(latencyMs), pct(latencyMs, 95)
        by route
    | sort hits desc
Q
echo "  Query 5: 5xx count by route"
cat << 'Q'
    filter status >= 500
    | stats count() by route, status
Q
echo "  Insights is billed per GB of data SCANNED. Narrow the time"
echo "  range and log groups before running."

echo ""
echo "[ METRIC FILTER: turn log lines into a metric ]"
echo "  Use when you can't change the app but need an alarm."
echo "  aws logs put-metric-filter \\"
echo "    --log-group-name $LOG_GROUP \\"
echo "    --filter-name app-errors \\"
echo "    --filter-pattern '\"ERROR\"' \\"
echo "    --metric-transformations \\"
echo "      metricName=AppErrors,metricNamespace=DevOpsJourney/App,metricValue=1,defaultValue=0"
echo "  Now alarm on AppErrors like any other metric."
echo "  NOTE: filters only count lines logged AFTER creation."

echo ""
echo "[ SUBSCRIPTION FILTERS: stream logs elsewhere ]"
echo "  Real-time delivery to Lambda, Kinesis, or Firehose"
echo "  (then to S3 / OpenSearch / a SIEM)."

echo ""
echo "[ LOG CLASSES AND COST ]"
echo "  Ingestion is the main cost (roughly \$0.50/GB)."
echo "  Standard vs Infrequent Access log class (cheaper, fewer features)."
echo "  Cost tips: don't log DEBUG in prod, don't log full payloads,"
echo "  set retention, sample noisy logs."

echo ""
echo "[ 🔒 NEVER LOG SECRETS OR PII ]"
echo "  Passwords, tokens, card numbers, full Authorization headers."
echo "  Logs are widely readable and retained. Mask before logging."
echo "============================================"
