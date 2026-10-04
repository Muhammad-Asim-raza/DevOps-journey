# Day 51 Exercises — CI/CD Security Scanning
**Date:** Aug 8 2026
**Status:** ✅ Completed

---

## Exercise 1: SAST with Bandit ✅
- [x] Created intentionally vulnerable app
- [x] Ran Bandit scan on vulnerable code
- [x] Identified: SQL injection, command injection
- [x] Identified: hardcoded secrets, weak crypto
- [x] Set security gate (HIGH = fail pipeline)

### Proof: practices/day51-practice/exercise1-proof.txt

### SAST Vulnerabilities Found
B105: Hardcoded password (API_KEY, DB_PASSWORD)
B602: subprocess with shell=True (cmd injection)
B608: SQL expression (SQL injection risk)
B324: MD5/SHA1 for passwords (weak crypto)

---

## Exercise 2: SCA with pip-audit ✅
- [x] Scanned intentionally outdated requirements.txt
- [x] Found CVEs in flask, urllib3, cryptography, PyYAML
- [x] Understood CVSS severity levels
- [x] Documented fix strategies

### Proof: practices/day51-practice/exercise2-proof.txt

### CVE Severity Gates
CRITICAL (9.0-10.0) → FAIL immediately
HIGH (7.0-8.9)     → FAIL or require review
MEDIUM (4.0-6.9)   → Track + schedule fix
LOW (0.1-3.9)      → Informational

---

## Exercise 3: Image Scanning with Trivy ✅
- [x] Scanned python:3.9 (old, many CVEs)
- [x] Scanned Dockerfile for misconfigurations
- [x] Scanned for embedded secrets
- [x] Documented CI/CD integration

### Proof: practices/day51-practice/exercise3-proof.txt

### Trivy Scan Types
trivy image IMAGE       = CVE scan
trivy config .          = Dockerfile misconfigs
trivy fs .              = filesystem scan
trivy --scanners secret = find leaked secrets

---

## Exercise 4: Secret Scanning ✅
- [x] Manual pattern scanning
- [x] Gitleaks configuration (.gitleaks.toml)
- [x] Pre-commit hook setup
- [x] Response plan if secret committed

### Proof: practices/day51-practice/exercise4-proof.txt

### If Secret Is Committed
1. ROTATE THE SECRET IMMEDIATELY
2. git filter-repo to remove from history
3. Force push all branches
4. Alert security team
5. Audit for unauthorized use

---

## Exercise 5: IaC Scanning ✅
- [x] Created intentionally insecure Terraform
- [x] Ran Checkov scan
- [x] Documented common misconfigurations
- [x] Compared our K8s manifests (secure!)

### Proof: practices/day51-practice/exercise5-proof.txt

### IaC Issues Found in Demo Terraform
- S3 publicly readable (CKV_AWS_20)
- Security group all ports open (CKV_AWS_25)
- RDS not encrypted (CKV_AWS_17)
- RDS publicly accessible
- No backup (skip_final_snapshot=true)

---

## Complete Security Pipeline (Workflow 28)

### Pipeline Stages
1. Secret Scanning (first! cheapest)
2. SAST (source code analysis)
3. SCA (dependency CVEs)
4. Container Scanning (image CVEs)
5. IaC Scanning (infrastructure)
6. Final Report (GITHUB_STEP_SUMMARY)

### Schedule
Every PR → run all scans (fast feedback)
Every push to main → run all scans
Weekly cron → catch new CVEs in unchanged code

---

## Summary
All 5 exercises completed Aug 8 2026

Scripts:
- 01-sast-bandit.sh
- 02-sca-dependencies.sh
- 03-image-scanning.sh
- 04-secret-scanning.sh
- iac-examples/checkov-demo.sh
- security-reference.sh

Workflows: 28-security-pipeline.yml

Key concepts mastered:
- DevSecOps philosophy (shift left)
- SAST (Bandit, Semgrep)
- SCA (pip-audit, safety, npm audit)
- Image scanning (Trivy)
- Secret scanning (Gitleaks)
- IaC scanning (Checkov, tfsec)
- Security gates and thresholds
- SARIF reports for GitHub
- Scheduled scans (weekly CVE check)
- Pre-commit hooks for prevention
