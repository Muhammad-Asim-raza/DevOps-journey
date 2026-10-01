# Day 50 Exercises — Deployment Strategies
**Date:** Aug 7 2026
**Status:** ✅ Completed

---

## Exercise 1: Recreate Strategy ✅
- [x] deployment.yaml with type: Recreate
- [x] deploy.sh with stop→deploy→start flow
- [x] Understood when downtime is acceptable

### Proof: practices/day50-practice/exercise1-proof.txt

### When to Use
Dev environments, DB schema migrations
When v1 and v2 CANNOT coexist
When clean state is needed

---

## Exercise 2: Rolling Update ✅
- [x] deployment.yaml with maxSurge and maxUnavailable
- [x] rollout-commands.sh with all kubectl commands
- [x] Understood minReadySeconds, progressDeadlineSeconds

### Proof: practices/day50-practice/exercise2-proof.txt

### Zero Downtime Config
maxSurge: 2         # extra pods allowed
maxUnavailable: 0   # never kill before new ready
minReadySeconds: 10 # must be stable for 10s

### Rollback
kubectl rollout undo deployment/NAME
kubectl rollout undo deployment/NAME --to-revision=2

---

## Exercise 3: Blue-Green ✅
- [x] blue-deployment.yaml (current production)
- [x] green-deployment.yaml (new version)
- [x] service.yaml (selector controls traffic)
- [x] switch-traffic.sh with health check pre-switch

### Proof: practices/day50-practice/exercise3-proof.txt

### Traffic Switch
kubectl patch svc app-service \
  -p '{"spec":{"selector":{"color":"green"}}}'

### Instant Rollback
kubectl patch svc app-service \
  -p '{"spec":{"selector":{"color":"blue"}}}'

---

## Exercise 4: Canary Deployment ✅
- [x] stable-deployment.yaml (19 pods = 95%)
- [x] canary-deployment.yaml (1 pod = 5%)
- [x] canary-service.yaml (routes to both)
- [x] canary-promote.sh (promote/rollback/increase)

### Proof: practices/day50-practice/exercise4-proof.txt

### Traffic Split by Replica Count
19 stable + 1 canary = 5%
15 stable + 5 canary = 25%
0 stable + 20 canary = 100% (promote)

---

## Exercise 5: Feature Flags ✅
- [x] feature-flag-demo.py with consistent hashing
- [x] demo-flags.sh with all concepts
- [x] Understood: dark launch, percentage rollout, A/B

### Proof: practices/day50-practice/exercise5-proof.txt

### Consistent Hashing
hash(user_id + flag_name) % 100 < rollout_pct
Same user = always same result
No flicker between requests

---

## Decision Framework

Q1: Can afford downtime? NO → skip Recreate
Q2: v1+v2 can coexist? NO → Recreate+maintenance
Q3: Need instant rollback? YES → Blue-Green
Q4: High-risk change? YES → Canary
Q5: Product feature? YES → Feature Flags
DEFAULT: Rolling Update

---

## Summary
All 5 exercises completed Aug 7 2026

Files created:
- strategies/recreate/ (deployment.yaml, deploy.sh)
- strategies/rolling/ (deployment.yaml, commands.sh)
- strategies/blue-green/ (blue, green, service, switch)
- strategies/canary/ (stable, canary, service, promote)
- strategies/feature-flags/ (demo.py, demo.sh)
- scripts/strategy-decision.sh

Key concepts mastered:
- All 5 deployment strategies
- Recreate: simple, downtime, clean state
- Rolling: zero downtime, default for most apps
- Blue-Green: instant rollback, 2x cost
- Canary: gradual, metric-driven, low blast radius
- Feature flags: decouple deploy from release
- Kubernetes manifest config per strategy
- Decision framework
- Combining strategies in production
