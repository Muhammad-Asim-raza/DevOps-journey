echo '#!/bin/bash'
echo '# ================================================'
echo '# 01-create-alb.sh'
echo '# Build an ALB: SGs -> target group -> ALB -> listener'
echo '# Author: Asim Raza - Day 66'
echo '# ================================================'
echo 'set -uo pipefail'
echo 'REGION="${AWS_DEFAULT_REGION:-us-east-1}"'
echo 'APP="devops-journey"'

echo "============================================"
echo "   BUILD AN APPLICATION LOAD BALANCER"
echo "============================================"

echo 'VPC_ID=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true \'
echo '    --query '\''Vpcs[0].VpcId'\'' --output text --region "$REGION" 2>/dev/null) || VPC_ID="vpc-demo"'
echo 'SUBNETS=$(aws ec2 describe-subnets --filters Name=vpc-id,Values="$VPC_ID" \'
echo '    --query '\''Subnets[:2].SubnetId'\'' --output text --region "$REGION" 2>/dev/null) || SUBNETS="subnet-a subnet-b"'
echo "echo \"VPC: \$VPC_ID  Subnets: \$SUBNETS\""

echo ""
echo "[ STEP 1: Security groups (Day 55 SG-to-SG pattern) ]"
echo 'ALB_SG=$(aws ec2 create-security-group --group-name "${APP}-alb-sg" \'
echo '    --description "ALB" --vpc-id "$VPC_ID" --query GroupId --output text \'
echo '    --region "$REGION" 2>/dev/null) || ALB_SG="sg-alb-demo"'
echo 'APP_SG=$(aws ec2 create-security-group --group-name "${APP}-app-sg" \'
echo '    --description "App behind ALB" --vpc-id "$VPC_ID" --query GroupId --output text \'
echo '    --region "$REGION" 2>/dev/null) || APP_SG="sg-app-demo"'

echo ''
echo '# ALB accepts the internet'
echo 'for P in 80 443; do'
echo '  aws ec2 authorize-security-group-ingress --group-id "$ALB_SG" --protocol tcp \'
echo '      --port $P --cidr 0.0.0.0/0 --region "$REGION" >/dev/null 2>&1'
echo 'done'
echo '# App accepts ONLY the ALB'\''s security group'
echo 'aws ec2 authorize-security-group-ingress --group-id "$APP_SG" --protocol tcp \'
echo '    --port 8000 --source-group "$ALB_SG" --region "$REGION" >/dev/null 2>&1'
echo 'echo "  ALB SG $ALB_SG: 80/443 from anywhere"'
echo 'echo "  App SG $APP_SG: 8000 from the ALB SG only (not from the internet)"'

echo ""
echo "[ STEP 2: Target group ]"
echo 'TG_ARN=$(aws elbv2 create-target-group --name "${APP}-tg" \'
echo '    --protocol HTTP --port 8000 --vpc-id "$VPC_ID" --target-type ip \'
echo '    --health-check-protocol HTTP --health-check-path /health \'
echo '    --health-check-interval-seconds 15 --health-check-timeout-seconds 5 \'
echo '    --healthy-threshold-count 2 --unhealthy-threshold-count 3 \'
echo '    --matcher HttpCode=200 \'
echo '    --query '\''TargetGroups[0].TargetGroupArn'\'' --output text \'
echo '    --region "$REGION" 2>/dev/null) || TG_ARN="arn:aws:elasticloadbalancing:${REGION}:123456789012:targetgroup/${APP}-tg/demo"'
echo "  \$TG_ARN"
echo "  --target-type ip   : required for Fargate/awsvpc and EKS pods"
echo "                       (use 'instance' for classic EC2 targets)"
echo "  /health            : your Day 52 endpoint"
echo "  healthy 2 / unhealthy 3 at 15 s: in after ~30 s, out after ~45 s"

echo '# Faster scale-in / deploys'
echo 'aws elbv2 modify-target-group-attributes --target-group-arn "$TG_ARN" \'
echo '    --attributes Key=deregistration_delay.timeout_seconds,Value=30 \'
echo '    --region "$REGION" >/dev/null 2>&1'
echo "  deregistration_delay 30 s (default 300 s makes deploys slow)"

echo ""
echo "[ STEP 3: Load balancer ]"
echo 'LB_ARN=$(aws elbv2 create-load-balancer --name "${APP}-alb" \'
echo '    --type application --scheme internet-facing \'
echo '    --subnets $SUBNETS --security-groups "$ALB_SG" \'
echo '    --query '\''LoadBalancers[0].LoadBalancerArn'\'' --output text \'
echo '    --region "$REGION" 2>/dev/null) || LB_ARN="arn:aws:elasticloadbalancing:${REGION}:123456789012:loadbalancer/app/${APP}-alb/demo"'
echo "  \$LB_ARN"
echo 'aws elbv2 wait load-balancer-available --load-balancer-arns "$LB_ARN" \'
echo '    --region "$REGION" 2>/dev/null'
echo 'DNS=$(aws elbv2 describe-load-balancers --load-balancer-arns "$LB_ARN" \'
echo '    --query '\''LoadBalancers[0].DNSName'\'' --output text --region "$REGION" 2>/dev/null) \'
echo '    || DNS="${APP}-alb-123456.${REGION}.elb.amazonaws.com"'
echo "  DNS: \$DNS"

echo ""
echo "[ STEP 4: Listener (HTTP :80 for now) ]"
echo 'aws elbv2 create-listener --load-balancer-arn "$LB_ARN" --protocol HTTP --port 80 \'
echo '    --default-actions Type=forward,TargetGroupArn="$TG_ARN" \'
echo '    --region "$REGION" >/dev/null 2>&1 && echo "  ✅ Listener created" || echo "  (would create)"'

echo ""
echo "[ STEP 5: Register targets ]"
echo "  aws elbv2 register-targets --target-group-arn \$TG_ARN \\"
echo "    --targets Id=10.0.10.25,Port=8000 Id=10.0.11.31,Port=8000"
echo "  For ECS/EKS you do NOT register by hand: the service/controller does it."
echo "  Check:  aws elbv2 describe-target-health --target-group-arn \$TG_ARN"
echo "  States: initial, healthy, unhealthy, draining, unused"

echo ""
echo "[ TEST ]"
echo "  curl -i http://\$DNS/health"

echo 'cat > ../configs/alb-config.sh << EOF'
echo 'REGION=$REGION'
echo 'LB_ARN=$LB_ARN'
echo 'TG_ARN=$TG_ARN'
echo 'ALB_SG=$ALB_SG'
echo 'APP_SG=$APP_SG'
echo 'DNS=$DNS'
echo 'EOF'

echo ""
echo "[ COST: ALB ~\$0.0225/hr (~\$16/month) + LCU usage. DELETE after labs ]"
echo "  aws elbv2 delete-load-balancer --load-balancer-arn \$LB_ARN"
echo "  aws elbv2 delete-target-group  --target-group-arn \$TG_ARN"
echo "============================================"
