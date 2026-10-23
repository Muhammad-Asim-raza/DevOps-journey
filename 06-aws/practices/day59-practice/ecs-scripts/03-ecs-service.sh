#!/bin/bash
# ================================================
# 03-ecs-service.sh
# Create ECS Cluster and Fargate Service
# Author: Asim Raza - Day 59
# ================================================
set -euo pipefail

echo 'source ../ecs-configs/ecr-config.sh 2>/dev/null'
ACCOUNT_ID="123456789012"
REGION="us-east-1"

APP_NAME="devops-cicd-platform"
CLUSTER_NAME="${APP_NAME}-cluster"

echo "============================================"
echo "   CREATE ECS CLUSTER AND SERVICE"
echo "   Author: Asim Raza - Day 59"
echo "============================================"

# ── STEP 1: Create ECS Cluster ──────────────────
echo ""
echo "[ STEP 1: Create ECS Cluster ]"
echo ""
echo "  Cluster = logical grouping of compute"
echo "  Fargate cluster: no EC2 instances to manage!"
echo ""

echo "aws ecs create-cluster \
    --cluster-name \"$CLUSTER_NAME\" \
    --capacity-providers FARGATE FARGATE_SPOT \
    --default-capacity-provider-strategy \
        capacityProvider=FARGATE,weight=1 \
        capacityProvider=FARGATE_SPOT,weight=1 \
    --settings name=containerInsights,value=enabled \
    --tags key=Project,value=devops-journey \
           key=Day,value=59 \
    --region \"$REGION\""

echo "  (PRINT ONLY - Cluster not created: $CLUSTER_NAME)"

echo ""
echo "  Capacity providers explained:"
echo "  FARGATE:      on-demand pricing (always available)"
echo "  FARGATE_SPOT: up to 70% cheaper, can be interrupted"
echo "  weight=1 each: 50/50 split between providers"
echo "  For prod: FARGATE only (reliable)"
echo "  For dev:  FARGATE_SPOT (cheaper)"
echo ""
echo "  containerInsights=enabled:"
echo "  Detailed CPU/memory metrics per container"
echo "  Costs extra (~$0.35/million metrics)"

echo ""
echo "[ STEP 2: Create Service Security Group ]"
echo ""

echo "aws ec2 describe-vpcs \
    --filters \"Name=isDefault,Values=true\" \
    --query 'Vpcs[0].VpcId' \
    --output text \
    --region \"$REGION\""

VPC_ID="vpc-demo"

echo "aws ec2 create-security-group \
    --group-name \"${APP_NAME}-ecs-sg\" \
    --description \"ECS Fargate tasks - ${APP_NAME}\" \
    --vpc-id \"$VPC_ID\" \
    --tag-specifications \
        \"ResourceType=security-group,Tags=[{Key=Name,Value=${APP_NAME}-ecs-sg}]\" \
    --query 'GroupId' \
    --output text \
    --region \"$REGION\""

ECS_SG_ID="sg-ecs-demo"

echo "  ECS Security Group: $ECS_SG_ID"

# Allow inbound from ALB only (in production)
echo "aws ec2 authorize-security-group-ingress \
    --group-id \"$ECS_SG_ID\" \
    --protocol tcp \
    --port 8000 \
    --cidr \"10.0.0.0/8\" \
    --region \"$REGION\""

echo "  Port 8000 allowed from VPC (ALB would be SG reference)"

# Get subnets
echo "aws ec2 describe-subnets \
    --filters \"Name=vpc-id,Values=${VPC_ID}\" \
    --query 'Subnets[*].SubnetId' \
    --output text \
    --region \"$REGION\""

SUBNET_IDS="subnet-demo1,subnet-demo2"

echo "  Subnets: $SUBNET_IDS"

# ── STEP 3: Create ECS Service ──────────────────
echo ""
echo "[ STEP 3: Create ECS Service ]"
echo ""
echo "  Service keeps N tasks running at all times"
echo "  Integrates with load balancer"
echo "  Handles rolling deployments"
echo ""

# Service definition
cat > ../ecs-configs/service-definition.json << EOF
{
    "cluster": "${CLUSTER_NAME}",
    "serviceName": "${APP_NAME}-service",
    "taskDefinition": "${APP_NAME}",
    "launchType": "FARGATE",
    "desiredCount": 2,
    "networkConfiguration": {
        "awsvpcConfiguration": {
            "subnets": ["subnet-demo1","subnet-demo2"],
            "securityGroups": ["${ECS_SG_ID}"],
            "assignPublicIp": "DISABLED"
        }
    },
    "deploymentConfiguration": {
        "minimumHealthyPercent": 100,
        "maximumPercent": 200,
        "deploymentCircuitBreaker": {
            "enable": true,
            "rollback": true
        }
    },
    "deploymentController": {
        "type": "ECS"
    },
    "enableECSManagedTags": true,
    "enableExecuteCommand": true,
    "tags": [
        {"key": "Project", "value": "devops-journey"},
        {"key": "Day",     "value": "59"}
    ]
}
EOF

echo "  Key service settings:"
echo ""
echo "  desiredCount: 2"
echo "  → Always keep 2 tasks running"
echo "  → If one crashes: start replacement immediately"
echo ""
echo "  minimumHealthyPercent: 100"
echo "  → During deploy: never below 2 healthy tasks"
echo "  → Zero downtime rolling update"
echo ""
echo "  maximumPercent: 200"
echo "  → During deploy: up to 4 tasks (2 old + 2 new)"
echo "  → Start new before stopping old"
echo ""
echo "  deploymentCircuitBreaker: true"
echo "  → If deploy fails health checks: AUTO-ROLLBACK"
echo "  → Critical for production safety!"
echo ""
echo "  enableExecuteCommand: true"
echo "  → ECS Exec: ssh-like access to running containers"
echo "  → aws ecs execute-command --command '/bin/sh'"
echo ""

echo "aws ecs create-service \
    --cli-input-json \
        file://../ecs-configs/service-definition.json \
    --region \"$REGION\""

echo "  (PRINT ONLY - Service not created: ${APP_NAME}-service)"

# ── STEP 4: Watch Deployment ─────────────────────
echo ""
echo "[ STEP 4: Monitor Service Deployment ]"
echo ""
echo "  # Watch service status:"
echo "  aws ecs describe-services \\"
echo "    --cluster $CLUSTER_NAME \\"
echo "    --services ${APP_NAME}-service \\"
echo "    --query 'services[0].deployments' \\"
echo "    --output table"
echo ""
echo "  # Watch running tasks:"
echo "  aws ecs list-tasks \\"
echo "    --cluster $CLUSTER_NAME \\"
echo "    --service-name ${APP_NAME}-service"
echo ""
echo "  # Describe a specific task:"
echo "  aws ecs describe-tasks \\"
echo "    --cluster $CLUSTER_NAME \\"
echo "    --tasks TASK_ARN"
echo ""
echo "  # View container logs (CloudWatch):"
echo "  aws logs tail /ecs/${APP_NAME} --follow"
echo ""
echo "  # ECS Exec (connect to running container):"
echo "  aws ecs execute-command \\"
echo "    --cluster $CLUSTER_NAME \\"
echo "    --task TASK_ARN \\"
echo "    --container app \\"
echo "    --interactive \\"
echo "    --command '/bin/sh'"
echo ""
echo "  # This is the modern alternative to SSH into containers!"
echo "  # Works on Fargate (no EC2 to SSH into)"

echo ""
echo "============================================"
echo "   ECS SERVICE CREATION COMPLETE"
echo "   Cluster: $CLUSTER_NAME"
echo "============================================"
