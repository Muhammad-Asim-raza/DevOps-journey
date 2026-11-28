#!/bin/bash
# ================================================
# 02-listener-rules.sh
# HTTPS listener, redirect, path/host routing
# Author: Asim Raza - Day 66
# ================================================
source ../configs/alb-config.sh 2>/dev/null || {
  REGION=us-east-1; LB_ARN=LB_ARN; TG_ARN=TG_ARN; }
CERT_ARN="${CERT_ARN:-arn:aws:acm:us-east-1:123456789012:certificate/demo}"

echo "============================================"
echo "   LISTENER RULES, HTTPS, REDIRECT"
echo "============================================"

echo ""
echo "[ 1. HTTPS listener with an ACM certificate ]"
echo "  aws elbv2 create-listener --load-balancer-arn \$LB_ARN \\"
echo "    --protocol HTTPS --port 443 \\"
echo "    --certificates CertificateArn=$CERT_ARN \\"
echo "    --ssl-policy ELBSecurityPolicy-TLS13-1-2-2021-06 \\"
echo "    --default-actions Type=forward,TargetGroupArn=\$TG_ARN"
echo "  TLS terminates at the ALB (cert from ACM, free, auto-renews)."
echo "  Traffic ALB -> target can stay HTTP inside the VPC, or be re-encrypted"
echo "  (HTTPS target group) if compliance requires end-to-end TLS."
echo "  Pick a modern TLS policy; avoid old ones permitting TLS 1.0/1.1."

echo ""
echo "[ 2. Redirect HTTP -> HTTPS (modify the :80 listener) ]"
echo "  aws elbv2 modify-listener --listener-arn \$HTTP_LISTENER_ARN \\"
echo "    --default-actions 'Type=redirect,RedirectConfig={Protocol=HTTPS,Port=443,StatusCode=HTTP_301}'"
echo "  (Day 60 EKS Ingress annotation did the same thing for you.)"

echo ""
echo "[ 3. Path-based routing ]"
echo "  aws elbv2 create-rule --listener-arn \$HTTPS_LISTENER_ARN \\"
echo "    --priority 10 \\"
echo "    --conditions Field=path-pattern,Values='/api/*' \\"
echo "    --actions Type=forward,TargetGroupArn=\$API_TG_ARN"

echo "  Lower priority number is evaluated first. Default rule is last."

echo ""
echo "[ 4. Host-based routing ]"
echo "  --conditions Field=host-header,Values='admin.yourdomain.com'"

echo ""
echo "[ 5. Fixed response (maintenance page / block path) ]"
echo "  --actions 'Type=fixed-response,FixedResponseConfig={StatusCode=503,ContentType=text/plain,MessageBody=Back soon}'"

echo ""
echo "[ 6. Weighted target groups = blue/green or canary ]"
echo "cat << 'EOF'"
echo '  aws elbv2 modify-listener --listener-arn $LISTENER_ARN \'
echo "    --default-actions '[{"
echo '      "Type":"forward",'
echo '      "ForwardConfig":{"TargetGroups":['
echo '        {"TargetGroupArn":"BLUE_TG","Weight":90},'
echo '        {"TargetGroupArn":"GREEN_TG","Weight":10}]}}]''
echo 'EOF'
echo "  Unlike Route 53 weighting (Day 65), this splits per REQUEST,"
echo "  instantly, with no DNS caching. Rollback = set green to 0."

echo ""
echo "[ 7. Useful attributes ]"
echo "  idle_timeout.timeout_seconds (default 60) - raise for long requests"
echo "  routing.http.drop_invalid_header_fields.enabled=true (security)"
echo "  deletion_protection.enabled=true (production)"
echo "  access_logs.s3.enabled=true  (logs to S3, Day 57 lifecycle)"
echo "  aws elbv2 modify-load-balancer-attributes --load-balancer-arn \$LB_ARN \\"
echo "    --attributes Key=deletion_protection.enabled,Value=true \\"
echo "                 Key=routing.http.drop_invalid_header_fields.enabled,Value=true"

echo ""
echo "[ 8. Client IP behind an ALB ]"
echo "  The target sees the ALB's IP. The real client is in the"
echo "  X-Forwarded-For header (also X-Forwarded-Proto, -Port)."
echo "  Trust only the LAST hop's value; clients can forge earlier ones."
echo "============================================"
