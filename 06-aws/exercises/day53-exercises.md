# Day 53 Exercises — AWS Cloud Fundamentals
**Date:** Aug 10 2026
**Status:** ✅ Completed

---

## Exercise 1: Cloud Computing Concepts ✅
- [x] Explained IaaS vs PaaS vs SaaS
- [x] Documented why cloud beats on-premises
- [x] Explained three cloud providers and AWS advantage
- [x] Documented cloud benefits

### Proof: practices/day53-practice/exercise1-proof.txt

### Three Service Models
IaaS (EC2, S3): rent infrastructure, manage OS up
PaaS (RDS, Lambda): rent platform, manage app only
SaaS (Gmail): just use the service

### Why AWS
32% market share (largest)
200+ services
Most DevOps job requirements
Most documentation and community

---

## Exercise 2: AWS Global Infrastructure ✅
- [x] Regions explained (33+)
- [x] Availability Zones explained
- [x] Multi-AZ for HA understood
- [x] Region selection criteria

### Proof: practices/day53-practice/exercise2-proof.txt

### Region Selection Criteria
1. Latency: closest to users
2. Compliance: data residency (GDPR → EU regions)
3. Pricing: us-east-1 typically cheapest
4. Services: check service availability in region

### Multi-AZ Pattern (High Availability)
Deploy to: us-east-1a AND us-east-1b
If us-east-1a fails → us-east-1b serves traffic
This is the foundation of HA on AWS

---

## Exercise 3: Shared Responsibility Model ✅
- [x] AWS responsibilities documented
- [x] Customer responsibilities documented
- [x] Service-type variation understood
- [x] Security implications clear

### Proof: practices/day53-practice/exercise3-proof.txt

### Interview Answer Template
"AWS is responsible for security OF the cloud —
physical infrastructure, hardware, networking,
hypervisor, and managed service software.
I am responsible for security IN the cloud —
my data, IAM configuration, OS patching on EC2,
application security, and network configuration.
This shifts based on service type: EC2 means I patch
the OS, RDS means AWS patches the database engine."

---

## Exercise 4: AWS CLI Setup ✅
- [x] AWS CLI installed
- [x] Configuration guide written
- [x] First CLI commands documented
- [x] Named profiles explained

### Proof: practices/day53-practice/exercise4-proof.txt

### Essential CLI Commands
aws configure                    = set credentials
aws sts get-caller-identity      = verify who I am
aws ec2 describe-regions         = list regions
aws s3 ls                        = list my buckets

### NEVER commit ~/.aws/ to Git!
Add to .gitignore:
.aws/
*.pem
credentials

---

## AWS Service Map (for Phase 6)

### Compute
EC2 → virtual machines (Day 56)
ECS → containers (Day 59)
EKS → Kubernetes (Day 60)
Lambda → serverless (Day 62)

### Storage
S3 → object storage (Day 57)
EBS → block storage (with EC2)
ECR → container registry

### Networking
VPC → private network (Day 55)
ALB → load balancer (Day 66)
Route53 → DNS (Day 65)

### Database
RDS → managed SQL (Day 58)
DynamoDB → managed NoSQL
ElastiCache → managed Redis

---

## Summary
All 4 exercises completed Aug 10 2026

Scripts created:
- 01-aws-account-setup.sh
- 02-install-aws-cli.sh
- 03-aws-services-overview.sh
- 04-aws-pricing.sh
- 05-first-cli-commands.sh
- aws-fundamentals-reference.sh

Key concepts mastered:
- Cloud computing models (IaaS/PaaS/SaaS)
- Why cloud vs on-premises
- AWS vs Azure vs GCP
- Regions and Availability Zones
- Multi-AZ for High Availability
- Shared Responsibility Model
- AWS Free Tier and billing safety
- AWS CLI installation and configuration
- 200+ services categorized
- Pricing models (On-Demand/Reserved/Spot)
- Core DevOps services list
