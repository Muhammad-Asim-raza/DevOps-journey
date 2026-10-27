# Day 61 Exercises — AWS CloudFormation
**Date:** Aug 18 2026
**Status:** ✅ Completed

---

## Exercise 1: Template Anatomy ✅
- [x] All 7 template sections explained
- [x] Parameters with validation
- [x] Conditions (IsProduction)
- [x] Mappings for environment-based config
- [x] Resources with DeletionPolicy

### Proof: practices/day61-practice/exercise1-proof.txt

### Most Important Concept
Resources is the ONLY required section.
Everything else (Parameters, Outputs) is optional.

---

## Exercise 2: Intrinsic Functions ✅
- [x] !Ref (parameters and resources)
- [x] !Sub (string substitution)
- [x] !GetAtt (resource attributes)
- [x] !FindInMap (lookup tables)
- [x] !If (conditional values)
- [x] !Select + !GetAZs (AZ selection)
- [x] !ImportValue (cross-stack)

### Proof: practices/day61-practice/exercise2-proof.txt

### Most Used Functions
!Ref, !Sub, !GetAtt, !If — learn these deeply.
Others (!Select, !GetAZs, !FindInMap) are common.
!ImportValue essential for nested/cross-stack.

---

## Exercise 3: Production VPC Template ✅
- [x] Day 55 VPC architecture as CloudFormation
- [x] Conditions (NeedNatGateway)
- [x] All subnets (public, private, database)
- [x] NAT Gateway with Condition
- [x] Route tables and associations
- [x] Outputs with Export (cross-stack)

### Proof: practices/day61-practice/exercise3-proof.txt

### Day 55 → Day 61 Connection
Day 55: created VPC manually with CLI
Day 61: SAME architecture as CloudFormation template
Benefits: reproducible, reviewable, version controlled

---

## Exercise 4: Stack Operations ✅
- [x] validate-template
- [x] cloudformation deploy
- [x] Change Sets (create/describe/execute)
- [x] Drift detection
- [x] Stack statuses
- [x] 10 best practices

### Proof: practices/day61-practice/exercise4-proof.txt

### Change Set Workflow (always for prod)
1. create-change-set
2. describe-change-set → check Replacement=True!
3. execute-change-set (if safe)
OR
3. delete-change-set (if not safe, redesign)

---

## Summary
All 4 exercises completed Aug 18 2026

Files created:
- templates/01-template-anatomy.yaml (annotated)
- templates/02-production-vpc.yaml (Day 55 as IaC)
- nested-stacks/root-stack.yaml
- scripts/01-intrinsic-functions.sh
- scripts/02-stack-operations.sh
- scripts/03-cfn-best-practices.sh
- cfn-reference.sh

Key concepts mastered:
- IaC benefits (reproducible, auditable, reviewable)
- CloudFormation vs Terraform comparison
- Template anatomy (7 sections)
- Parameters with validation
- Conditions (!Equals, !If)
- Mappings (environment-based lookup)
- All major intrinsic functions
- Stack operations (create, update, delete)
- Change Sets (always for production!)
- Drift detection
- Deletion policies (Delete, Retain, Snapshot)
- Nested stacks pattern
- Cross-stack references (!ImportValue)
- 10 CloudFormation best practices
- Termination protectiono
