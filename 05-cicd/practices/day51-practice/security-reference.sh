#!/bin/bash
# ================================================
# security-reference.sh
# CI/CD Security Scanning Complete Reference
# Author: Asim Raza - Day 51
# ================================================

echo "============================================"
echo "   CI/CD SECURITY SCANNING REFERENCE"
echo "   Author: Asim Raza - Day 51"
echo "============================================"

echo ""
echo "[ DEVSECOPS PHILOSOPHY ]"
echo "  Shift Left: find vulnerabilities EARLIER"
echo "  Development → Review → QA → Staging → Production"
echo "  Dev: \$80/fix  →  Production exploited: \$760,000+"
echo "  Automate security checks in every pipeline"

echo ""
echo "[ 5 SCANNING TYPES ]"
printf "%-8s %-25s %-35s %-20s\n" \
    "Type" "What" "Tool (Python)" "When"
printf "%-8s %-25s %-35s %-20s\n" \
    "----" "----" "-------------" "----"
printf "%-8s %-25s %-35s %-20s\n" \
    "SAST" "Source code" "bandit, semgrep" "Every commit"
printf "%-8s %-25s %-35s %-20s\n" \
    "SCA" "Dependencies" "pip-audit, safety" "Every commit"
printf "%-8s %-25s %-35s %-20s\n" \
    "Image" "Docker image" "trivy, grype" "After build"
printf "%-8s %-25s %-35s %-20s\n" \
    "Secret" "Leaked creds" "gitleaks" "Every commit"
printf "%-8s %-25s %-35s %-20s\n" \
    "IaC" "Infra code" "checkov, tfsec" "Before apply"

echo ""
echo "[ QUICK COMMANDS ]"
echo "  # SAST:"
echo "  bandit -r src/ -ll -ii"
echo "  semgrep --config p/python src/"
echo ""
echo "  # SCA:"
echo "  pip-audit -r requirements.txt"
echo "  safety check -r requirements.txt"
echo "  npm audit --audit-level=high"
echo ""
echo "  # Image scan:"
echo "  trivy image myapp:v1.0"
echo "  trivy image --severity HIGH,CRITICAL myapp:v1"
echo "  trivy config ./  (Dockerfile)"
echo ""
echo "  # Secret scan:"
echo "  gitleaks detect --source ."
echo "  gitleaks protect --staged  (pre-commit)"
echo ""
echo "  # IaC scan:"
echo "  checkov -d . --framework terraform"
echo "  checkov -d . --framework kubernetes"
echo "  tfsec ."

echo ""
echo "[ SECURITY GATE THRESHOLDS ]"
echo "  CRITICAL CVE:     FAIL pipeline immediately"
echo "  HIGH severity:    FAIL or require review"
echo "  MEDIUM severity:  WARNING, track/schedule"
echo "  LOW severity:     INFO only"
echo "  Secrets found:    FAIL immediately + rotate"
echo "  IaC misconfig:    FAIL on CRITICAL, WARN on HIGH"

echo ""
echo "[ SARIF REPORTS ]"
echo "  SARIF = Static Analysis Results Interchange Format"
echo "  GitHub natively reads SARIF files"
echo "  Uploads to: Security → Code scanning alerts"
echo ""
echo "  Upload in GitHub Actions:"
echo "  - uses: github/codeql-action/upload-sarif@v2"
echo "    with:"
echo "      sarif_file: results.sarif"
echo ""
echo "  Tools that output SARIF:"
echo "  trivy --format sarif"
echo "  CodeQL (GitHub native)"
echo "  Semgrep --sarif"
echo "  Checkov -o sarif"

echo ""
echo "[ SCHEDULED SCANS ]"
echo "  schedule:"
echo "    - cron: '0 2 * * 1'  # Monday 2am UTC"
echo ""
echo "  Why weekly scheduled scans?"
echo "  New CVEs published daily in NVD database"
echo "  Your code unchanged but deps now vulnerable"
echo "  Weekly scan: catch new CVEs in existing code"

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
