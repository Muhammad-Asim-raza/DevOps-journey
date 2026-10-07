# Day 54 Exercises — AWS IAM
**Date:** Aug 11 2026
**Status:** ✅ Completed

---

## Exercise 1: IAM Components ✅
- [x] Root vs User vs Group vs Role vs Policy
- [x] Policy JSON anatomy (Effect/Action/Resource)
- [x] Default deny principle
- [x] Explicit deny override

### Proof: practices/day54-practice/exercise1-proof.txt

### Policy Anatomy
Version: "2012-10-17" (always this)
Effect: Allow | Deny
Action: ["s3:GetObject", "s3:PutObject"]
Resource: ["arn:aws:s3:::bucket/*"]
Condition: optional extra restrictions

---

## Exercise 2: IAM Policy Types ✅
- [x] AWS Managed (broad, pre-built)
- [x] Customer Managed (specific, reusable)
- [x] Inline (avoid, not reusable)
- [x] Resource-based (on the resource, cross-account)
- [x] SCPs (org-wide limits)

### Proof: practices/day54-practice/exercise2-proof.txt

---

## Exercise 3: IAM Roles for Services ✅
- [x] Trust policies (WHO can assume)
- [x] EC2 instance profiles
- [x] Lambda execution roles
- [x] GitHub Actions OIDC (no keys!)
- [x] Cross-account roles

### Proof: practices/day54-practice/exercise3-proof.txt

### GitHub Actions OIDC (Key Pattern)
permissions:
  id-token: write
→ No AWS keys stored in GitHub
→ IAM role trusted by GitHub OIDC provider
→ Credentials auto-expire after 1 hour

---

## Exercise 4: IAM Best Practices ✅
- [x] 10 best practices documented
- [x] Least privilege explained
- [x] Roles vs users for services
- [x] MFA requirements
- [x] Credential rotation

### Proof: practices/day54-practice/exercise4-proof.txt

---

## IAM Policies Written

### CICDPipelinePolicy
ECR push/pull + ECS deploy + S3 artifacts
Specific resources only (not *)

### EC2AppServerPolicy
SSM parameters + Secrets Manager + CloudWatch logs + S3 read
Only what the app server needs

### DeveloperReadOnlyPolicy
Read production + Full development access
Explicit DENY on production destructive actions

### S3 Bucket Policies
Public read, cross-account, enforce encryption

### Trust Policies
EC2, Lambda, ECS, GitHub Actions OIDC, cross-account

---

## Summary
All 4 exercises completed Aug 11 2026

Files created:
- iam-policies/01-policy-anatomy.json
- iam-policies/02-arn-format.sh
- iam-policies/03-policy-types.sh
- iam-policies/04-devops-policies.json
- iam-policies/05-s3-bucket-policy.json
- iam-policies/06-trust-policies.json
- iam-scripts/01-iam-cli-reference.sh
- iam-scripts/02-iam-setup-demo.sh
- iam-scripts/03-iam-best-practices.sh
- iam-reference.sh

Key concepts mastered:
- IAM components hierarchy
- Policy JSON structure
- ARN format for all services
- Five policy types
- Principle of Least Privilege
- Roles vs Users for services
- Instance profiles for EC2
- OIDC for GitHub Actions (no keys)
- Trust policies (who can assume)
- Resource-based policies
- IAM best practices (10 rules)
- CLI commands for all operations
- Credential report for auditing

