#!/bin/bash
APP_NAME="devops-cicd-platform"
CLUSTER_NAME="${APP_NAME}-cluster"

# Register scalable target
aws application-autoscaling register-scalable-target \
    --service-namespace ecs \
    --scalable-dimension ecs:service:DesiredCount \
    --resource-id "service/${CLUSTER_NAME}/${APP_NAME}-service" \
    --min-capacity 2 \
    --max-capacity 20

# Scale on CPU utilization
aws application-autoscaling put-scaling-policy \
    --service-namespace ecs \
    --scalable-dimension ecs:service:DesiredCount \
    --resource-id "service/${CLUSTER_NAME}/${APP_NAME}-service" \
    --policy-name "${APP_NAME}-cpu-scaling" \
    --policy-type TargetTrackingScaling \
    --target-tracking-scaling-policy-configuration '{
        "TargetValue": 70.0,
        "PredefinedMetricSpecification": {
            "PredefinedMetricType": "ECSServiceAverageCPUUtilization"
        },
        "ScaleInCooldown": 300,
        "ScaleOutCooldown": 60
    }'
# TargetValue=70: maintain 70% CPU across all tasks
# ScaleOut cooldown: 60s (add tasks faster)
# ScaleIn cooldown: 300s (remove tasks slowly - avoid thrashing)

# Scale on memory
aws application-autoscaling put-scaling-policy \
    --service-namespace ecs \
    --scalable-dimension ecs:service:DesiredCount \
    --resource-id "service/${CLUSTER_NAME}/${APP_NAME}-service" \
    --policy-name "${APP_NAME}-memory-scaling" \
    --policy-type TargetTrackingScaling \
    --target-tracking-scaling-policy-configuration '{
        "TargetValue": 80.0,
        "PredefinedMetricSpecification": {
            "PredefinedMetricType": "ECSServiceAverageMemoryUtilization"
        },
        "ScaleInCooldown": 300,
        "ScaleOutCooldown": 60
    }'

# Scale on ALB request count per target
aws application-autoscaling put-scaling-policy \
    --service-namespace ecs \
    --scalable-dimension ecs:service:DesiredCount \
    --resource-id "service/${CLUSTER_NAME}/${APP_NAME}-service" \
    --policy-name "${APP_NAME}-request-scaling" \
    --policy-type TargetTrackingScaling \
    --target-tracking-scaling-policy-configuration '{
        "TargetValue": 1000.0,
        "PredefinedMetricSpecification": {
            "PredefinedMetricType": "ALBRequestCountPerTarget",
            "ResourceLabel": "ALB_ARN_SUFFIX/TG_ARN_SUFFIX"
        }
    }'
# Target: 1000 requests per task
# >1000/task → scale out, <1000/task → scale in
