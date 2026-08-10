# Day 23 Exercises — GitHub Actions & CI/CD
**Date:** Jul 12 2026
**Status:** ✅ Completed

---

## Exercise 1: Sample App Setup ✅
- [x] Created Python app with functions
- [x] Written comprehensive tests
- [x] Tests pass locally
- [x] Dockerfile created

### Proof
See: practices/day23-practice/exercise1-proof.txt
See: practices/day23-practice/sample-app/

### Test Results
All 11 tests passing:
- test_add_positive ✅
- test_add_negative ✅
- test_subtract ✅
- test_multiply ✅
- test_divide_normal ✅
- test_divide_by_zero ✅
- test_greet_valid ✅
- test_greet_empty ✅
- test_health_check_returns_dict ✅
- test_health_check_status ✅
- test_health_check_has_version ✅

---

## Exercise 2: GitHub Actions Workflows ✅
- [x] hello-world.yml (basics)
- [x] ci-pipeline.yml (tests on every push)
- [x] env-and-secrets.yml (variables)
- [x] devops-workflow.yml (full CI/CD)
- [x] scheduled-tasks.yml (cron + manual)

### Proof
See: practices/day23-practice/exercise2-proof.txt
See: practices/day23-practice/workflows/

### Workflows Created
hello-world.yml     = learn basic syntax
ci-pipeline.yml     = real CI with tests
env-and-secrets.yml = variables and secrets
devops-workflow.yml = full 4-stage pipeline
scheduled-tasks.yml = cron and manual

---

## Exercise 3: Workflow Anatomy ✅
- [x] Understood triggers (push PR schedule)
- [x] Understood jobs and parallelism
- [x] Understood steps (uses vs run)
- [x] Understood needs for dependencies
- [x] Understood matrix strategy

### Proof
See: practices/day23-practice/exercise3-proof.txt

### Key Concepts
Triggers: push pull_request schedule workflow_dispatch
Runner: ubuntu-latest windows-latest macos-latest
Steps: uses (action) or run (shell command)
needs: job dependency (wait for other job)
if: conditional execution
matrix: run job multiple times with different values
secrets: encrypted, never shown in logs

---

## CI/CD Concepts Learned

### CI (Continuous Integration)
Every push triggers:
→ Lint/quality check
→ Unit tests
→ Security scan
→ Build artifact

### CD (Continuous Delivery)
On main branch:
→ Deploy to staging
→ Integration tests
→ Deploy to production
→ Notify team

### Important Actions
actions/checkout@v4       = download code (ALWAYS first)
actions/setup-python@v4   = install Python
actions/upload-artifact@v3 = save build files
actions/download-artifact@v3 = get saved files

### Context Variables
${{ github.sha }}      = unique commit identifier
${{ github.actor }}    = who pushed code
${{ github.ref_name }} = branch name
${{ secrets.NAME }}    = encrypted values

---

## Summary
All exercises completed on Jul 12 2026

Scripts written:
- github-actions-reference.sh

Workflows created in .github/workflows/:
- hello-world.yml
- ci-pipeline.yml
- env-and-secrets.yml
- devops-workflow.yml
- scheduled-tasks.yml

Sample app created:
- sample-app/app.py
- sample-app/test_app.py
- sample-app/Dockerfile
- sample-app/requirements.txt

Proof files:
- exercise1-proof.txt (tests passing)
- exercise2-proof.txt (workflow files)
- exercise3-proof.txt (anatomy reference)
- script-output-actions.txt
