#!/bin/bash
# ================================================
# 03-alarms.sh
# SNS topic + alarms (Lambda errors, API 5xx, RDS storage)
# Author: Asim Raza - Day 64
# ================================================
REGION="${AWS_DEFAULT_REGION:-us-east-1}"
EMAIL="${ALERT_EMAIL:-you@example.com}"
FUNCTION="devops-journey-api-handler"
DB="devops-journey-postgres"

echo "============================================"
echo "   ALARMS AND NOTIFICATIONS"
echo "============================================"

echo ""
echo "[ STEP 1: SNS topic = where alarms send messages ]"
TOPIC_ARN=$(aws sns create-topic --name devops-journey-alerts \
    --query TopicArn --output text --region "$REGION" 2>/dev/null) \
    || TOPIC_ARN="arn:aws:sns:${REGION}:123456789012:devops-journey-alerts"
echo "  Topic: $TOPIC_ARN"
aws sns subscribe --topic-arn "$TOPIC_ARN" --protocol email \
    --notification-endpoint "$EMAIL" --region "$REGION" >/dev/null 2>&1 && \
    echo "  ✅ Subscribed $EMAIL (CONFIRM the email AWS sends!)" || \
    echo "  (would subscribe $EMAIL)"
echo "  An unconfirmed subscription receives NOTHING."
echo "  Real teams: SNS → Slack/PagerDuty via AWS Chatbot or webhook."

echo ""
echo "[ STEP 2: Lambda errors alarm ]"
aws cloudwatch put-metric-alarm \
    --alarm-name "${FUNCTION}-errors" \
    --alarm-description "Lambda errors >= 3 in 5 min" \
    --namespace AWS/Lambda --metric-name Errors \
    --dimensions Name=FunctionName,Value="$FUNCTION" \
    --statistic Sum --period 300 \
    --evaluation-periods 1 --threshold 3 \
    --comparison-operator GreaterThanOrEqualToThreshold \
    --treat-missing-data notBreaching \
    --alarm-actions "$TOPIC_ARN" --ok-actions "$TOPIC_ARN" \
    --region "$REGION" 2>/dev/null && \
    echo "  ✅ Errors alarm created" || echo "  (would create)"
echo "  --ok-actions: also notify on recovery"
echo "  notBreaching: no errors = no datapoints = healthy"

echo ""
echo "[ STEP 3: Lambda p99 latency alarm (percentile) ]"
aws cloudwatch put-metric-alarm \
    --alarm-name "${FUNCTION}-p99-duration" \
    --namespace AWS/Lambda --metric-name Duration \
    --dimensions Name=FunctionName,Value="$FUNCTION" \
    --extended-statistic p99 --period 300 \
    --evaluation-periods 3 --datapoints-to-alarm 2 \
    --threshold 3000 --comparison-operator GreaterThanThreshold \
    --treat-missing-data notBreaching \
    --alarm-actions "$TOPIC_ARN" --region "$REGION" 2>/dev/null && \
    echo "  ✅ p99 alarm created (2 of 3 periods > 3000 ms)" || \
    echo "  (would create)"
echo "  Percentiles use --extended-statistic, not --statistic."

echo ""
echo "[ STEP 4: RDS free storage alarm (warn BEFORE disk full) ]"
aws cloudwatch put-metric-alarm \
    --alarm-name "${DB}-low-storage" \
    --namespace AWS/RDS --metric-name FreeStorageSpace \
    --dimensions Name=DBInstanceIdentifier,Value="$DB" \
    --statistic Minimum --period 300 \
    --evaluation-periods 2 --threshold 5368709120 \
    --comparison-operator LessThanThreshold \
    --alarm-actions "$TOPIC_ARN" --region "$REGION" 2>/dev/null && \
    echo "  ✅ Storage alarm created (< 5 GiB free)" || \
    echo "  (would create)"
echo "  Threshold is in BYTES: 5 GiB = 5368709120."

echo ""
echo "[ STEP 5: Billing alarm (Day 53 promise kept) ]"
echo "  Billing metrics live ONLY in us-east-1 and the account must"
echo "  have 'Receive Billing Alerts' enabled in billing preferences."
aws cloudwatch put-metric-alarm \
    --alarm-name monthly-bill-over-10-usd \
    --namespace AWS/Billing --metric-name EstimatedCharges \
    --dimensions Name=Currency,Value=USD \
    --statistic Maximum --period 21600 --evaluation-periods 1 \
    --threshold 10 --comparison-operator GreaterThanThreshold \
    --alarm-actions "$TOPIC_ARN" --region us-east-1 2>/dev/null && \
    echo "  ✅ Billing alarm created" || echo "  (would create)"

echo ""
echo "[ COMPOSITE ALARMS: cut alert noise ]"
echo "  Combine alarms with AND/OR so you page once, not 5 times:"
echo "  aws cloudwatch put-composite-alarm \\"
echo "    --alarm-name api-degraded \\"
echo "    --alarm-rule 'ALARM(api-5xx) AND ALARM(lambda-errors)' \\"
echo "    --alarm-actions $TOPIC_ARN"

echo ""
echo "[ MANAGE ALARMS ]"
echo "  aws cloudwatch describe-alarms --state-value ALARM"
echo "  aws cloudwatch describe-alarm-history --alarm-name NAME"
echo "  aws cloudwatch set-alarm-state --alarm-name NAME \\"
echo "    --state-value ALARM --state-reason test    ← test the pipeline!"
echo "  aws cloudwatch delete-alarms --alarm-names NAME"

echo ""
echo "[ ALARM ACTIONS ]"
echo "  SNS notification | EC2 stop/terminate/reboot/recover"
echo "  Auto Scaling policy | Systems Manager OpsItem/Incident"

echo ""
echo "[ GOOD ALERTING PRINCIPLES ]"
echo "  1. Alert on SYMPTOMS users feel (errors, latency),"
echo "     not on every CAUSE (a CPU spike nobody feels)."
echo "  2. Every page must be actionable. If you ignore it, delete it."
echo "  3. Two severities: PAGE (wake someone) vs TICKET (business hours)."
echo "  4. Alarm on RATES (error %), not raw counts, when traffic varies."
echo "  5. Write a runbook link into the alarm description."
echo "  6. Test alarms with set-alarm-state."
echo "============================================"
