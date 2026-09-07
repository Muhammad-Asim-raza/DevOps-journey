# Day 39 Exercises — What is CI/CD & WHY It Exists
**Date:** Jul 27 2026
**Status:** ✅ Completed

---

## Exercise 1: Manual vs CI/CD Comparison ✅
- [x] Ran manual-deploy.sh simulation
- [x] Ran cicd-deploy.sh simulation
- [x] Understood the time and risk difference

### Proof
See: practices/day39-practice/exercise1-proof.txt

### Key Numbers
Manual:  2 days → 45 min deploy → 40% failure
CI/CD:   push code → 7 minutes → auto-deploy

### What I Learned
Manual deployment = human error, downtime, stress
CI/CD = reproducible, fast, reliable, no downtime

---

## Exercise 2: CI/CD Vocabulary ✅
- [x] Understood pipeline, stage, runner, artifact
- [x] Understood trigger, environment, deployment
- [x] Understood unit/integration/e2e/smoke tests
- [x] Understood SAST, DAST, SCA
- [x] Understood DORA metrics
- [x] Understood deployment strategies

### Proof
See: practices/day39-practice/exercise2-proof.txt

### Key Terms
Pipeline   = series of automated stages
Runner     = server that executes stages
Artifact   = output of a build (image, jar)
Trigger    = what starts the pipeline
SAST       = scan source code for vulnerabilities
DORA       = deployment frequency, lead time,
             failure rate, recovery time

---

## Exercise 3: DevOps Culture ✅
- [x] Understood how CI/CD changes team dynamics
- [x] Understood Dev + Ops collaboration
- [x] Understood the Three Ways of DevOps
- [x] Understood DevOps engineer's CI/CD role

### Proof
See: practices/day39-practice/exercise3-proof.txt

### DevOps Engineer CI/CD Role
Build the pipeline (not the products)
Design stages, choose tools, write YAML
Maintain runners, optimize speed
Ensure security, onboard teams

---

## CI/CD Concepts Summary

### Three Types
CI = Continuous Integration (test on merge)
CD = Continuous Delivery (human approves prod)
CD = Continuous Deployment (auto to prod)

### Pipeline Stages
Source → Build → Test → Security → Image → Staging → Prod → Notify

### Tools We Study
GitHub Actions (Days 40-45) = cloud, YAML
Jenkins (Days 46-47) = self-hosted, Groovy
GitLab CI (Day 48) = built-in, .yml
ArgoCD (Day 49) = GitOps, Kubernetes

### Why CI/CD is Non-Negotiable
Amazon: 11.7 seconds between deploys
Netflix: thousands per day
Without CI/CD: monthly deploys, 40% failure
With CI/CD: daily deploys, <5% failure

---

## Summary
All 3 exercises completed on Jul 27 2026

Scripts written:
- manual-deploy.sh (the old way)
- cicd-deploy.sh (the CI/CD way)
- cicd-vocabulary.sh (terms reference)
- devops-culture.sh (culture impact)
- cicd-reference.sh (full reference)

Proof files:
- exercise1-proof.txt (comparison)
- exercise2-proof.txt (vocabulary)
- exercise3-proof.txt (culture)
- script-output-cicd.txt

Key concepts mastered:
- WHY CI/CD exists (manual pain)
- CI vs CD vs CD (three meanings)
- Pipeline stages and their purpose
- CI/CD tools landscape
- DORA metrics
- Deployment strategies
- DevOps culture shift
- DevOps engineer's role in CI/CD
