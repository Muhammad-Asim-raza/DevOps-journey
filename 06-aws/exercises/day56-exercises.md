# Day 56 Exercises — AWS EC2
**Date:** Aug 13 2026
**Status:** ✅ Completed

---

## Exercise 1: EC2 Concepts and Instance Types ✅
- [x] Instance family naming convention
- [x] t vs m vs c vs r vs i families
- [x] AMI explained and how to find them
- [x] Key pair creation and chmod 400

### Proof: practices/day56-practice/exercise1-proof.txt

### Instance Type Naming
t3.micro = family(t) + gen(3) + size(micro)
t = burstable (cheap, variable CPU)
m = main/balanced (web servers)
c = compute (CPU intensive)
r = RAM (memory intensive)

---

## Exercise 2: Launch EC2 with CLI ✅
- [x] Full launch walkthrough written
- [x] Security group with correct rules
- [x] User data bootstrap script
- [x] IMDSv2 enforced (HttpTokens=required)
- [x] EBS: gp3 + encrypted

### Proof: practices/day56-practice/exercise2-proof.txt

### Security Best Practices Applied
✅ SSH (22) allowed from MY IP only (not 0.0.0.0/0)
✅ IMDSv2 required (blocks SSRF attacks)
✅ EBS encrypted
✅ IAM role not access keys
✅ Tags for identification and cost tracking

---

## Exercise 3: User Data and IMDS ✅
- [x] User data scripts for Docker, nginx, ECR pull
- [x] Debugging user data (cloud-init logs)
- [x] IMDSv2 token process
- [x] How SDK uses IMDS for role credentials

### Proof: practices/day56-practice/exercise3-proof.txt

### Key IMDS Endpoints
instance-id, instance-type, local-ipv4, public-ipv4
placement/availability-zone, placement/region
iam/security-credentials/ROLE-NAME ← auto-rotating!
user-data ← your bootstrap script

---

## Exercise 4: EC2 Lifecycle ✅
- [x] All instance states documented
- [x] Start/stop/reboot/terminate commands
- [x] EBS volume types compared
- [x] Connect methods (SSH vs SSM)

### Proof: practices/day56-practice/exercise4-proof.txt

### Connect Method Preference
Production: SSM Session Manager
  - No port 22 needed (smaller attack surface)
  - No key pair management
  - Works on private instances
  - All commands logged to CloudTrail

Learning: SSH with key pair

### States
pending → running → stopping → stopped
↓
terminated (PERMANENT - cannot recover!)
stopped ≠ terminated!

---

## Summary
All 4 exercises completed Aug 13 2026

Scripts created:
- ec2-scripts/01-ami-reference.sh
- ec2-scripts/02-launch-ec2.sh
- ec2-scripts/03-instance-metadata.sh
- ec2-scripts/04-ec2-lifecycle.sh
- userdata-scripts/01-userdata-reference.sh
- ec2-reference.sh

Key concepts mastered:
- EC2 instance types and families
- AMI (template for instances)
- Key pairs and SSH security
- Security group rules for EC2
- Full launch workflow via CLI
- User data (bootstrap scripts)
- IMDS (instance metadata service)
- IMDSv2 and SSRF protection
- EBS storage types (gp3 preferred)
- EC2 instance states
- SSM Session Manager (preferred connect)
- Elastic IP management
- SSH troubleshooting
- Cost: stop (no CPU bill) vs terminate (deleted)
