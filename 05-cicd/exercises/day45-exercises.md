# Day 45 Exercises — Deploy Automation
**Date:** Aug 2 2026
**Status:** ✅ Completed

---

## Exercise 1: Deploy Scripts ✅
- [x] deploy.sh (server-side deployment)
- [x] rollback.sh (emergency rollback)
- [x] smoke-test.sh (post-deploy verification)
- [x] All with set -euo pipefail
- [x] Health check polling loop
- [x] Automatic rollback on health failure

### Proof: practices/day45-practice/exercise1-proof.txt

### deploy.sh Flow
1. Pull new image
2. Save current image (rollback point)
3. Update service (docker-compose / docker run)
4. Health check loop (max 60s)
5. If healthy: success
6. If timeout: rollback to previous image

---

## Exercise 2: Staging Deployment ✅
- [x] Build → staging → smoke tests → integration tests
- [x] concurrency: cancel-in-progress: false
- [x] environment: staging with URL
- [x] Slack notification (simulated)
- [x] Integration tests on live staging

### Proof: practices/day45-practice/exercise2-proof.txt
### Workflow: .github/workflows/24-deploy-staging.yml

---

## Exercise 3: Production Deployment ✅
- [x] Pre-deployment checks (business hours, no :latest)
- [x] GitHub environment approval gate
- [x] Rolling update simulation
- [x] Post-deploy health verification
- [x] 2-minute monitoring period
- [x] Slack notification
- [x] Deployment record in GitHub

### Proof: practices/day45-practice/exercise3-proof.txt
### Workflow: .github/workflows/25-deploy-production.yml

### Critical: Block :latest in Production
if echo "$IMAGE_TAG" | grep -q ":latest$"; then
  echo "❌ BLOCKED: Cannot deploy :latest!"
  exit 1
fi

---

## Exercise 4: Blue-Green + Canary ✅
- [x] Blue-Green: deploy to idle, switch traffic
- [x] Canary: 5% → monitor → 100% or rollback
- [x] Automatic rollback on error rate threshold
- [x] Monitoring loop with metric checks

### Proof: practices/day45-practice/exercise4-proof.txt
### Workflows: 26-blue-green-deploy.yml, 27-canary-rollback.yml

---

## Deployment Automation Patterns

### Environment Promotion Flow
code push → main branch
  → auto-deploy staging
  → smoke tests pass
  → integration tests pass
  → SLACK: "Ready for production"
  → manual trigger: deploy production
  → GitHub approval gate (required reviewer)
  → production rolling update
  → health checks pass
  → monitoring period
  → SLACK: "Production deployed ✅"

### Rollback Decision Tree
Health check fails after deploy?
  → Automatic rollback to previous image
  → Notify team via Slack
  → Exit code 1 (pipeline fails)
  → GitHub deployment marked as failed

Error rate spike post-deploy (canary)?
  → Automatic: set canary to 0%
  → 100% traffic back to stable
  → Team notified immediately

---

## Summary
All 4 exercises completed Aug 2 2026

Scripts: deploy.sh, rollback.sh, smoke-test.sh
Workflows: 24 25 26 27 (4 workflows)

Key concepts mastered:
- Deployment strategies comparison
- SSH deployment pattern
- Health check polling loops
- Automatic rollback on failure
- Environment promotion (staging → prod)
- GitHub environment approval gates
- Blue-green deployment automation
- Canary with auto-rollback
- Post-deploy monitoring
- Slack notifications
