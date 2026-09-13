# Day 42 Exercises — Secrets & Environment Management
**Date:** Jul 30 2026
**Status:** ✅ Completed

---

## Exercise 1: Secrets in Workflows ✅
- [x] Accessed secrets via ${{ secrets.NAME }}
- [x] Set job-level and step-level env vars
- [x] Used built-in GITHUB_TOKEN
- [x] Learned ::add-mask:: for dynamic masking
- [x] Documented safe and unsafe patterns

### Proof: practices/day42-practice/exercise1-proof.txt
### Workflow: .github/workflows/12-secrets-management.yml

### Safe Pattern
env:
  DB_PASS: ${{ secrets.DB_PASSWORD }}
run: myapp --connect  # reads from env var

### Unsafe Pattern (NEVER do)
run: myapp --password secret123  # in YAML = in Git!

---

## Exercise 2: OIDC Authentication ✅
- [x] Understood why OIDC > static keys
- [x] Learned token claims (repo/branch/actor)
- [x] Documented AWS IAM trust policy pattern
- [x] Set permissions: id-token: write

### Proof: practices/day42-practice/exercise2-proof.txt
### Workflow: .github/workflows/13-oidc-auth.yml

### OIDC Flow
GitHub → JWT token (per run, 1hr expiry)
→ AWS IAM validates via OIDC provider
→ AWS issues temporary credentials
→ No secrets stored anywhere!

---

## Exercise 3: Environment Configuration ✅
- [x] Branch-based environment detection
- [x] Different config per environment
- [x] Environment-specific secrets (same name)
- [x] Config file strategy

### Proof: practices/day42-practice/exercise3-proof.txt
### Workflow: .github/workflows/14-env-configuration.yml

### Configuration Pattern
main branch → production config
develop branch → staging config
feature/* → dev config (no deploy)

---

## Exercise 4: Secrets Scanning ✅
- [x] Manual pattern scanner
- [x] Sensitive file detection
- [x] .gitignore coverage check
- [x] Security report via GITHUB_STEP_SUMMARY

### Proof: practices/day42-practice/exercise4-proof.txt
### Workflow: .github/workflows/15-secrets-scanning.yml

---

## Secrets Hierarchy Summary

Organization Secrets → all repos in org
Repository Secrets → all workflows in repo
Environment Secrets → jobs using that environment

Precedence: Environment > Repository > Organization

## Secret vs Variable

SECRET (encrypted):
passwords, API keys, connection strings

VARIABLE (visible):
region, app name, feature flags, versions

## OIDC (Phase 6 deep dive)
Current: store keys as GitHub Secrets
Future: OIDC = no stored secrets at all

---

## Summary
All 4 exercises completed on Jul 30 2026

Workflows: 12 13 14 15 (4 workflows)
Scripts: setup-github-secrets.sh

Key concepts mastered:
- GitHub Secrets hierarchy
- Safe secret usage patterns
- ::add-mask:: for dynamic secrets
- OIDC authentication (no static keys)
- Environment-specific secrets
- Config file management across envs
- Secrets scanning patterns
- .gitignore security coverage
