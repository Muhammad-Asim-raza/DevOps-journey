# Day 49 Exercises — ArgoCD & GitOps
**Date:** Aug 6 2026
**Status:** ✅ Completed

---

## Exercise 1: GitOps Concepts ✅
- [x] Explained push vs pull deployment
- [x] Documented 4 GitOps principles
- [x] Illustrated ArgoCD architecture
- [x] Compared traditional CI/CD vs GitOps

### Proof: practices/day49-practice/exercise1-proof.txt

### GitOps 4 Principles
1. Declarative: desired state in files
2. Versioned: Git is the source of truth
3. Pulled: tool pulls from Git automatically
4. Reconciled: cluster always matches Git

---

## Exercise 2: Kubernetes Manifests ✅
- [x] deployment.yaml with all security settings
- [x] service.yaml (ClusterIP)
- [x] configmap.yaml (non-sensitive config)
- [x] base/kustomization.yaml
- [x] staging overlay (1 replica, DEBUG logs)
- [x] production overlay (5 replicas, immutable tag)

### Proof: practices/day49-practice/exercise2-proof.txt

### Kustomize Overlay Pattern
base/          = shared manifests (DRY)
overlays/
  staging/     = 1 replica, DEBUG logs
  production/  = 5 replicas, WARNING logs

Changes in base affect ALL environments.
Overlays PATCH without modifying base.

---

## Exercise 3: ArgoCD Applications ✅
- [x] demo-app-staging.yaml (automated sync)
- [x] demo-app-production.yaml (manual sync)
- [x] Documented all key fields
- [x] syncPolicy with prune and selfHeal
- [x] ignoreDifferences for HPA

### Proof: practices/day49-practice/exercise3-proof.txt

### Staging vs Production Sync
Staging:  automated (push to Git = auto-deploy)
Production: MANUAL (human clicks Sync in UI)

---

## Exercise 4: App of Apps ✅
- [x] Root Application watches applications/ dir
- [x] Manages other Applications
- [x] Bootstrap pattern understood

### Proof: practices/day49-practice/exercise4-proof.txt

---

## GitOps CI/CD Integration Pattern

### Two Repo Pattern
App Repo (source code):
  src/, tests/, Dockerfile
  CI/CD: GitHub Actions

GitOps Repo (manifests):
  K8s YAML, kustomization.yaml
  GitOps: ArgoCD watches this

### CI Updates GitOps Repo
After docker push myapp:sha-abc1234:
  cd gitops-configs
  kustomize edit set image myapp=myapp:sha-abc1234
  git commit -m "Deploy sha-abc1234"
  git push
  → ArgoCD detects change → syncs → deployed

### Rollback
git revert HEAD  (in GitOps repo)
ArgoCD detects: image reverted
Syncs cluster to previous image
Total time: < 2 minutes
No pipeline needed for rollback!

---

## ArgoCD Sync Status
Synced     = cluster matches Git ✅
OutOfSync  = cluster differs from Git ⚠️

ArgoCD Health Status
Healthy    = all pods running ✅
Progressing= rolling update in progress
Degraded   = pods crashing/failing ❌
Missing    = resource not yet created

---

## Summary
All 4 exercises completed Aug 6 2026

YAML files created:
- gitops-repo/apps/demo-app/base/deployment.yaml
- gitops-repo/apps/demo-app/base/service.yaml
- gitops-repo/apps/demo-app/base/configmap.yaml
- gitops-repo/apps/demo-app/base/kustomization.yaml
- gitops-repo/apps/demo-app/overlays/staging/kustomization.yaml
- gitops-repo/apps/demo-app/overlays/production/kustomization.yaml
- gitops-repo/argocd/applications/demo-app-staging.yaml
- gitops-repo/argocd/applications/demo-app-production.yaml
- gitops-repo/argocd/applications/app-of-apps.yaml

Scripts:
- install-scripts/01-install-argocd.sh
- install-scripts/02-kind-cluster.sh
- install-scripts/03-gitops-workflow.sh
- argocd-reference.sh

Key concepts mastered:
- GitOps vs traditional CI/CD
- Push vs Pull deployment models
- ArgoCD architecture
- Kubernetes manifests with security
- Kustomize base + overlays
- ArgoCD Application CRD
- Sync policies (automated vs manual)
- selfHeal and prune
- App of Apps pattern
- GitOps CI integration workflow
- ArgoCD CLI commands
