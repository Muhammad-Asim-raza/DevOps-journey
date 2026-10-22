#!/bin/bash
# ================================================
# 02-task-definition.sh
# Register ECS Task Definition
# Author: Asim Raza - Day 59
# PRINT-ONLY VERSION - NO AWS COMMANDS EXECUTED
# ================================================
set -euo pipefail

# Print source command instead of executing it
echo 'source ../ecs-configs/ecr-config.sh'

ACCOUNT_ID="123456789012"
REGION="us-east-1"
IMAGE_URI="123456789012.dkr.ecr.us-east-1.amazonaws.com/devops-cicd-platform"

APP_NAME="devops-cicd-platform"

# Print Git command instead of executing it
echo 'git -C "$HOME/DevOps-journey" rev-parse --short HEAD'
SHORT_SHA="demo123"

echo "============================================"
echo "   REGISTER ECS TASK DEFINITION"
echo "   Author: Asim Raza - Day 59"
echo "============================================"

# ── CREATE IAM ROLES FIRST ───────────────────────
echo ""
echo "[ STEP 1: Create IAM Roles ]"
echo ""
echo "  Two distinct roles needed:"
echo ""
echo "  1. EXECUTION ROLE (for ECS agent):"
echo "     What: pulls image from ECR, writes CloudWatch logs"
echo "     Policy: AmazonECSTaskExecutionRolePolicy (AWS managed)"
echo ""
echo "  2. TASK ROLE (for your application):"
echo "     What: S3, DynamoDB, Secrets Manager access"
echo "     Policy: your custom policy (least privilege)"

# Create execution role trust policy
cat > /tmp/ecs-trust-policy.json << 'EOF'
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

echo ""
echo "  Creating execution role..."

echo "aws iam create-role \
    --role-name ecsTaskExecutionRole \
    --assume-role-policy-document \
        file:///tmp/ecs-trust-policy.json"

echo "  (PRINT ONLY - execution role not created)"

echo "aws iam attach-role-policy \
    --role-name ecsTaskExecutionRole \
    --policy-arn \
        arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

echo "  (PRINT ONLY - execution policy not attached)"

echo ""
echo "  Creating task role (app permissions)..."

echo "aws iam create-role \
    --role-name \"${APP_NAME}-task-role\" \
    --assume-role-policy-document \
        file:///tmp/ecs-trust-policy.json"

echo "  (PRINT ONLY - task role not created)"

# Custom task policy - least privilege
cat > /tmp/task-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchLogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${REGION}:${ACCOUNT_ID}:log-group:/ecs/${APP_NAME}:*"
        },
        {
            "Sid": "ReadSecrets",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "arn:aws:secretsmanager:${REGION}:${ACCOUNT_ID}:secret:prod/${APP_NAME}/*"
        },
        {
            "Sid": "SSMParameters",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter",
                "ssm:GetParameters"
            ],
            "Resource": "arn:aws:ssm:${REGION}:${ACCOUNT_ID}:parameter/prod/${APP_NAME}/*"
        }
    ]
}
EOF

echo "aws iam put-role-policy \
    --role-name \"${APP_NAME}-task-role\" \
    --policy-name \"${APP_NAME}-task-policy\" \
    --policy-document file:///tmp/task-policy.json"

echo "  (PRINT ONLY - task policy not attached)"

# ── REGISTER TASK DEFINITION ─────────────────────
echo ""
echo "[ STEP 2: Register Task Definition ]"
echo ""

# Create CloudWatch log group - PRINT ONLY
echo "aws logs create-log-group \
    --log-group-name \"/ecs/${APP_NAME}\" \
    --region \"$REGION\""

# Task definition JSON
mkdir -p ../task-definitions

cat > ../task-definitions/devops-platform-td.json << EOF
{
    "family": "${APP_NAME}",
    "networkMode": "awsvpc",
    "requiresCompatibilities": ["FARGATE"],
    "cpu": "256",
    "memory": "512",
    "executionRoleArn": "arn:aws:iam::${ACCOUNT_ID}:role/ecsTaskExecutionRole",
    "taskRoleArn": "arn:aws:iam::${ACCOUNT_ID}:role/${APP_NAME}-task-role",
    "containerDefinitions": [
        {
            "name": "app",
            "image": "${IMAGE_URI}:sha-${SHORT_SHA}",
            "portMappings": [
                {
                    "containerPort": 8000,
                    "protocol": "tcp"
                }
            ],
            "essential": true,
            "environment": [
                {"name": "APP_ENV",   "value": "production"},
                {"name": "PORT",      "value": "8000"},
                {"name": "LOG_LEVEL", "value": "INFO"}
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/${APP_NAME}",
                    "awslogs-region": "${REGION}",
                    "awslogs-stream-prefix": "app",
                    "awslogs-create-group": "true"
                }
            },
            "healthCheck": {
                "command": [
                    "CMD-SHELL",
                    "python3 -c \"import urllib.request; urllib.request.urlopen('http://localhost:8000/health')\" || exit 1"
                ],
                "interval": 30,
                "timeout": 5,
                "retries": 3,
                "startPeriod": 60
            },
            "readonlyRootFilesystem": true,
            "user": "1001",
            "linuxParameters": {
                "capabilities": {
                    "drop": ["ALL"]
                },
                "initProcessEnabled": true
            },
            "mountPoints": [
                {
                    "sourceVolume": "tmp-volume",
                    "containerPath": "/tmp",
                    "readOnly": false
                }
            ]
        }
    ],
    "volumes": [
        {
            "name": "tmp-volume"
        }
    ],
    "tags": [
        {"key": "Project", "value": "devops-journey"},
        {"key": "Day", "value": "59"}
    ]
}
EOF

echo "  Task definition saved: task-definitions/devops-platform-td.json"
echo ""

# Register task definition - PRINT ONLY
echo "aws ecs register-task-definition \
    --cli-input-json \
        file://../task-definitions/devops-platform-td.json \
    --query 'taskDefinition.taskDefinitionArn' \
    --output text \
    --region \"$REGION\""

TASK_DEF_ARN="arn:aws:ecs:${REGION}:DEMO:task-definition/${APP_NAME}:1"

echo "  (PRINT ONLY - task definition not registered)"
echo "  Demo ARN: $TASK_DEF_ARN"

# ── SHOW ALL FIELD MEANINGS ──────────────────────
echo ""
echo "[ TASK DEFINITION FIELD SUMMARY ]"
echo ""
echo "  family:                 name (versioned auto)"
echo "  networkMode: awsvpc     each task = own ENI + IP"
echo "  requiresCompatibilities FARGATE or EC2"
echo "  cpu / memory:           task-level limits"
echo "  executionRoleArn:       ECS agent permissions"
echo "                          (pull ECR, write logs)"
echo "  taskRoleArn:            app permissions"
echo "                          (S3, DynamoDB, etc.)"
echo "  containerDefinitions:   list of containers"
echo "    image:                ECR URI:tag"
echo "    essential:true:       task stops if this stops"
echo "    environment:          non-sensitive config"
echo "    secrets:              from Secrets Manager/SSM"
echo "    logConfiguration:     CloudWatch Logs"
echo "    healthCheck:          container health probe"

echo ""
echo "[ EXECUTION ROLE vs TASK ROLE ]"
echo ""
printf "%-30s %-30s %-30s\n" "Who uses it" "Execution Role" "Task Role"
printf "%-30s %-30s %-30s\n" "-----------" "--------------" "---------"
printf "%-30s %-30s %-30s\n" "Used by" "ECS Agent" "Your App code"
printf "%-30s %-30s %-30s\n" "For" "Infrastructure" "Business logic"
printf "%-30s %-30s %-30s\n" "Examples" "Pull ECR image" "Read S3 bucket"
printf "%-30s %-30s %-30s\n" "" "Write CW Logs" "Call DynamoDB"
printf "%-30s %-30s %-30s\n" "" "Read Secrets" "Send SES email"
printf "%-30s %-30s %-30s\n" "Policy" "AWS Managed" "Your custom"

echo ""
echo "  This is the most common ECS interview question!"
echo "  Execution role = infrastructure operations"
echo "  Task role = application operations"

echo ""
echo "============================================"
echo "   TASK DEFINITION COMPLETE"
echo "   DEMO ARN: $TASK_DEF_ARN"
echo "   PRINT-ONLY MODE - NO AWS RESOURCES CREATED"
echo "============================================"
