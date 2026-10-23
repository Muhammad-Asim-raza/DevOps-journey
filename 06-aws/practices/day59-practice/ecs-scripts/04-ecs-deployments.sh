#!/bin/bash
# ================================================
# 04-ecs-deployments.sh
# ECS Deployments, Updates, and Auto-Scaling
# Author: Asim Raza - Day 59
# ================================================

echo 'source ../ecs-configs/ecr-config.sh 2>/dev/null'
ACCOUNT_ID="123456789012"
REGION="us-east-1"
IMAGE_URI="123456789012.dkr.ecr.us-east-1.amazonaws.com/devops-cicd-platform"

APP_NAME="devops-cicd-platform"
CLUSTER_NAME="${APP_NAME}-cluster"

echo "============================================"
echo "   ECS DEPLOYMENTS AND AUTO-SCALING"
echo "   Author: Asim Raza - Day 59"
echo "============================================"

echo ""
echo "[ ROLLING DEPLOYMENT (DEFAULT) ]"
echo ""
echo "  Default ECS rolling update:"
echo "  desiredCount: 2"
echo "  minimumHealthyPercent: 100  ← zero downtime"
echo "  maximumPercent: 200          ← 2x during deploy"
echo ""
echo "  Deployment timeline:"
echo "  Before:  [task-v1] [task-v1]"
echo "  Step 1:  [task-v1] [task-v1] [task-v2] [task-v2]"
echo "  Step 2:  [task-v2] [task-v2]"
echo "           (v1 tasks stopped after v2 healthy)"
echo ""
echo "  Deploy new version:"

echo 'git -C "$HOME/DevOps-journey" rev-parse --short HEAD'
NEW_SHA="newsha123"

echo ""
echo "  # Option 1: Update service with new image"
echo "  # (update task definition first, then service)"
echo ""
echo "  # Register new task def revision:"
echo "  aws ecs register-task-definition \\"
echo "    --family $APP_NAME \\"
echo "    --container-definitions '[{\"name\":\"app\",\"image\":\"${IMAGE_URI}:sha-${NEW_SHA}\",\"...\":\"...\"}]'"
echo ""
echo "  # Update service to use new revision:"
echo "  aws ecs update-service \\"
echo "    --cluster $CLUSTER_NAME \\"
echo "    --service ${APP_NAME}-service \\"
echo "    --task-definition ${APP_NAME}:LATEST_REVISION \\"
echo "    --force-new-deployment"
echo ""
echo "  # Option 2: Force redeploy (same task def):"
echo "  aws ecs update-service \\"
echo "    --cluster $CLUSTER_NAME \\"
echo "    --service ${APP_NAME}-service \\"
echo "    --force-new-deployment"
echo "  # Use when: ECR image changed but same tag"

echo ""
echo "[ DEPLOYMENT CIRCUIT BREAKER ]"
echo ""
echo "  Without circuit breaker:"
echo "  Deploy → bad code → health check fails forever"
echo "  ECS keeps retrying new tasks"
echo "  Result: 3am, 200 failed task restarts, no rollback"
echo ""
echo "  With circuit breaker (ALWAYS enable!):"
echo "  Deploy → 10% tasks fail health checks"
echo "  Circuit breaker trips"
echo "  ECS: AUTO-ROLLBACK to previous task def"
echo "  Result: old version restored in minutes"
echo ""
echo "  Enable in service:"
echo "  deploymentConfiguration:"
echo "    deploymentCircuitBreaker:"
echo "      enable: true"
echo "      rollback: true  ← this is the key one"

echo ""
echo "[ BLUE/GREEN DEPLOYMENT WITH CODE DEPLOY ]"
echo ""
echo "  Alternative deployment strategy:"
echo "  Requires: CodeDeploy + ALB"
echo ""
cat << 'DIAGRAM'
  ALB Listener
       │
  ┌────▼────────────────┐
  │  Target Group BLUE  │ ← 100% traffic (production)
  │  [task-v1] [task-v1]│
  └─────────────────────┘
  ┌─────────────────────┐
  │  Target Group GREEN │ ← 0% traffic (new version)
  │  [task-v2] [task-v2]│
  └─────────────────────┘

  1. CodeDeploy starts green tasks
  2. Green passes health checks
  3. Traffic shifted: 90% blue → 10% green (canary)
  4. After wait: 100% to green
  5. Blue tasks kept as rollback for 1 hour
  6. Rollback: instant (just shift traffic back)
DIAGRAM

echo ""
echo "  Use blue/green when:"
echo "  ✅ Need instant rollback (< 1 second)"
echo "  ✅ Production payment/auth services"
echo "  ✅ Zero-tolerance for errors"
echo "  Default rolling: good for most services"

echo ""
echo "[ AUTO-SCALING ]"
echo ""
echo "  Two types of ECS auto-scaling:"
echo ""
echo "  1. Service Auto-Scaling (scale tasks):"

cat > ../ecs-configs/autoscaling.sh << 'EOF'
#!/bin/bash
APP_NAME="devops-cicd-platform"
CLUSTER_NAME="${APP_NAME}-cluster"

# Register scalable target
echo 'aws application-autoscaling register-scalable-target \
    --service-namespace ecs \
    --scalable-dimension ecs:service:DesiredCount \
    --resource-id "service/${CLUSTER_NAME}/${APP_NAME}-service" \
    --min-capacity 2 \
    --max-capacity 20'

# Scale on CPU utilization
echo 'aws application-autoscaling put-scaling-policy \
    --service-namespace ecs \
    --scalable-dimension ecs:service:DesiredCount \
    --resource-id "service/${CLUSTER_NAME}/${APP_NAME}-service" \
    --policy-name "${APP_NAME}-cpu-scaling" \
    --policy-type TargetTrackingScaling \
    --target-tracking-scaling-policy-configuration '"'"'{
        "TargetValue": 70.0,
        "PredefinedMetricSpecification": {
            "PredefinedMetricType": "ECSServiceAverageCPUUtilization"
        },
        "ScaleInCooldown": 300,
        "ScaleOutCooldown": 60
    }'"'"''
# TargetValue=70: maintain 70% CPU across all tasks
# ScaleOut cooldown: 60s (add tasks faster)
# ScaleIn cooldown: 300s (remove tasks slowly - avoid thrashing)

# Scale on memory
echo 'aws application-autoscaling put-scaling-policy \
    --service-namespace ecs \
    --scalable-dimension ecs:service:DesiredCount \
    --resource-id "service/${CLUSTER_NAME}/${APP_NAME}-service" \
    --policy-name "${APP_NAME}-memory-scaling" \
    --policy-type TargetTrackingScaling \
    --target-tracking-scaling-policy-configuration '"'"'{
        "TargetValue": 80.0,
        "PredefinedMetricSpecification": {
            "PredefinedMetricType": "ECSServiceAverageMemoryUtilization"
        },
        "ScaleInCooldown": 300,
        "ScaleOutCooldown": 60
    }'"'"''

# Scale on ALB request count per target
echo 'aws application-autoscaling put-scaling-policy \
    --service-namespace ecs \
    --scalable-dimension ecs:service:DesiredCount \
    --resource-id "service/${CLUSTER_NAME}/${APP_NAME}-service" \
    --policy-name "${APP_NAME}-request-scaling" \
    --policy-type TargetTrackingScaling \
    --target-tracking-scaling-policy-configuration '"'"'{
        "TargetValue": 1000.0,
        "PredefinedMetricSpecification": {
            "PredefinedMetricType": "ALBRequestCountPerTarget",
            "ResourceLabel": "ALB_ARN_SUFFIX/TG_ARN_SUFFIX"
        }
    }'"'"''
# Target: 1000 requests per task
# >1000/task → scale out, <1000/task → scale in
EOF

chmod +x ../ecs-configs/autoscaling.sh
echo "  Auto-scaling config saved: ecs-configs/autoscaling.sh"

echo ""
echo "  Auto-scaling explained:"
echo "  min-capacity: 2    (always at least 2 tasks)"
echo "  max-capacity: 20   (scale up to 20 tasks max)"
echo "  CPU target: 70%    (scale when avg CPU > 70%)"
echo "  ScaleOut: 60s      (add tasks quickly)"
echo "  ScaleIn: 300s      (remove tasks slowly)"
echo ""
echo "  Scale in slowly = avoid removing tasks"
echo "  while traffic is still draining to them"

echo ""
echo "  2. Fargate Capacity Providers:"
echo "  FARGATE (on-demand):  reliable, full price"
echo "  FARGATE_SPOT:         70% cheaper, can interrupt"
echo "  Strategy: SPOT for batch, on-demand for web serving"
echo "  AWS gives 2-minute warning before reclaiming SPOT"

echo ""
echo "[ ECS EXEC (Connect to Container) ]"
echo ""
echo "  Like docker exec but for Fargate/ECS"
echo "  No SSH, no bastion, works on private tasks"
echo ""
echo "  Requires:"
echo "  1. enableExecuteCommand=true on service"
echo "  2. Task role: ssmmessages:* permission"
echo "  3. SSM Session Manager plugin installed"
echo ""
echo "  Connect:"
echo "  aws ecs execute-command \\"
echo "    --cluster $CLUSTER_NAME \\"
echo "    --task TASK_ARN \\"
echo "    --container app \\"
echo "    --interactive \\"
echo "    --command '/bin/sh'"
echo ""
echo "  Common debugging commands once inside:"
echo "  env                    ← see all env vars"
echo "  cat /proc/meminfo      ← memory usage"
echo "  netstat -tlnp          ← listening ports"
echo "  curl localhost:8000/health"

echo ""
echo "============================================"
echo "   DEPLOYMENTS AND SCALING COMPLETE"
echo "============================================"
