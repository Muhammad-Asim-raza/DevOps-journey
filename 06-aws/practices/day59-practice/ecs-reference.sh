#!/bin/bash
# ================================================
# ecs-reference.sh
# ECS Complete Reference
# Author: Asim Raza - Day 59
# ================================================

echo "============================================"
echo "   AWS ECS COMPLETE REFERENCE"
echo "   Author: Asim Raza - Day 59"
echo "============================================"

echo ""
echo "[ ECS CONCEPTS ]"
echo "  Cluster:         logical grouping of compute"
echo "  Task Definition: blueprint (image, CPU, RAM, ports)"
echo "  Task:            running container instance"
echo "  Service:         keeps N tasks alive, rolling deploys"

echo ""
echo "[ LAUNCH TYPES ]"
echo "  EC2:     you manage EC2 instances in cluster"
echo "  Fargate: AWS manages servers (serverless containers)"
echo "  Default choice: Fargate (less ops burden)"

echo ""
echo "[ IAM ROLES (most important ECS concept) ]"
echo "  Execution Role: ECS agent uses this"
echo "    → pull from ECR, write CloudWatch logs"
echo "    → Policy: AmazonECSTaskExecutionRolePolicy"
echo "  Task Role: YOUR app code uses this"
echo "    → S3, DynamoDB, Secrets Manager"
echo "    → Custom least-privilege policy"

echo ""
echo "[ ECR COMMANDS ]"
echo "  # Authenticate:"
echo "  aws ecr get-login-password --region REGION | \\"
echo "  docker login --username AWS --password-stdin ACCOUNT.dkr.ecr.REGION.amazonaws.com"
echo ""
echo "  # Create repo:"
echo "  aws ecr create-repository --repository-name NAME \\"
echo "    --image-scanning-configuration scanOnPush=true \\"
echo "    --image-tag-mutability IMMUTABLE"
echo ""
echo "  # List images:"
echo "  aws ecr list-images --repository-name NAME"

echo ""
echo "[ ECS CLI COMMANDS ]"
echo "  aws ecs list-clusters"
echo "  aws ecs list-services --cluster CLUSTER"
echo "  aws ecs list-tasks --cluster CLUSTER --service-name SVC"
echo "  aws ecs describe-services --cluster C --services SVC"
echo "  aws ecs update-service --cluster C --service SVC \\"
echo "    --task-definition TD:VERSION --force-new-deployment"
echo "  aws ecs execute-command --cluster C --task T \\"
echo "    --container app --interactive --command '/bin/sh'"

echo ""
echo "[ DEPLOYMENT SETTINGS ]"
echo "  minimumHealthyPercent: 100  (zero downtime)"
echo "  maximumPercent: 200         (2x during deploy)"
echo "  deploymentCircuitBreaker:"
echo "    enable: true"
echo "    rollback: true            (auto-rollback on failure!)"

echo ""
echo "[ AUTO-SCALING ]"
echo "  Target: CPU 70%, Memory 80%, 1000 req/task"
echo "  Scale out cooldown: 60s (fast)"
echo "  Scale in cooldown: 300s (slow, safe)"
echo "  min: 2, max: 20"

echo ""
echo "============================================"
echo "   ECS REFERENCE COMPLETE"
echo "============================================"
