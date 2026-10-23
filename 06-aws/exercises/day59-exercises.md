# Day 59 Exercises — AWS ECS
**Date:** Aug 16 2026
**Status:** ✅ Completed

---

## Exercise 1: ECR Setup ✅
- [x] Created ECR repository
- [x] IMMUTABLE tags configured
- [x] scan-on-push enabled
- [x] Lifecycle policy (keep 20 SHA images)
- [x] Authenticated Docker to ECR
- [x] Built and tagged Day 52 project image

### Proof: practices/day59-practice/exercise1-proof.txt

### ECR vs Docker Hub
No rate limits, IAM auth, private by default
Same-region pulls FREE
Integrated scanning (Trivy-based)

---

## Exercise 2: Task Definition ✅
- [x] Full task definition JSON written
- [x] Execution role vs task role distinction
- [x] Secrets from Secrets Manager (not env[])
- [x] Health check configured
- [x] readonlyRootFilesystem (Day 33 pattern)
- [x] Non-root user (UID 1001)

### Proof: practices/day59-practice/exercise2-proof.txt

### Key Distinction (interview critical)
Execution Role = ECS agent (pull ECR, write logs)
Task Role = your application (S3, DynamoDB)
They serve different purposes, never confuse them.

---

## Exercise 3: ECS Cluster and Service ✅
- [x] Fargate cluster created
- [x] Service with desiredCount=2
- [x] Circuit breaker with rollback
- [x] ECS Exec enabled
- [x] Deployment monitoring commands

### Proof: practices/day59-practice/exercise3-proof.txt

### Circuit Breaker (always enable)
Without: failing deploy loops forever
With: auto-rollback on consecutive health failures

---

## Exercise 4: Deployments and Auto-Scaling ✅
- [x] Rolling deployment (zero downtime config)
- [x] Blue/Green with CodeDeploy
- [x] Service auto-scaling (CPU, memory, requests)
- [x] Fargate Spot for cost savings
- [x] ECS Exec for debugging

### Proof: practices/day59-practice/exercise4-proof.txt

---

## ECS vs EKS Decision Guide

### Choose ECS when:
- Team new to containers
- AWS-native tools preferred
- Simpler microservices
- Fargate (no server management)
- Small-medium scale

### Choose EKS when:
- Large engineering teams
- Complex microservices
- Multi-cloud portability
- Kubernetes ecosystem tools
- Large scale

---

## Summary
All 4 exercises completed Aug 16 2026

Files created:
- ecs-scripts/01-ecr-setup.sh
- ecs-scripts/02-task-definition.sh
- ecs-scripts/03-ecs-service.sh
- ecs-scripts/04-ecs-deployments.sh
- task-definitions/devops-platform-td.json
- task-definitions/01-task-definition.json (annotated)
- ecs-configs/ecr-lifecycle.json
- ecs-configs/service-definition.json
- ecs-configs/autoscaling.sh
- ecs-reference.sh

Key concepts mastered:
- ECS vs EKS vs EC2 decision
- ECR repository and lifecycle policies
- Task definition (all fields explained)
- Execution role vs task role (critical!)
- Fargate launch type (serverless containers)
- ECS service (desired count, rolling deploy)
- Deployment circuit breaker
- ECS Exec (debug running containers)
- Service auto-scaling (CPU, memory, requests)
- Fargate Spot (70% cheaper)
- Blue/Green deployment via CodeDeploy
- Full CLI reference
