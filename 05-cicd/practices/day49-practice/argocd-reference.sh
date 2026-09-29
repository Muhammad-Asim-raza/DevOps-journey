#!/bin/bash
# ================================================
# argocd-reference.sh
# ArgoCD & GitOps Complete Reference
# Author: Asim Raza - Day 49
# ================================================

echo "============================================"
echo "   ARGOCD & GITOPS REFERENCE"
echo "   Author: Asim Raza - Day 49"
echo "============================================"

echo ""
echo "[ WHAT IS GITOPS ]"
echo "  Git = single source of truth"
echo "  Desired state described in Git (YAML)"
echo "  Tool (ArgoCD) makes cluster MATCH Git"
echo "  Changes via Git commit (not kubectl)"
echo "  Audit = git log"
echo "  Rollback = git revert"

echo ""
echo "[ PUSH vs PULL DEPLOYMENT ]"
echo "  Push (traditional CI/CD):"
echo "  Pipeline → has credentials → applies to cluster"
echo "  Cluster may drift after initial deploy"
echo ""
echo "  Pull (GitOps):"
echo "  ArgoCD IN cluster → watches Git → applies changes"
echo "  Credentials STAY IN cluster"
echo "  Continuous reconciliation (no drift)"

echo ""
echo "[ ARGOCD APPLICATION YAML ]"
cat << 'EOF'
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/org/configs
    targetRevision: main
    path: apps/my-app/overlays/staging
  destination:
    server: https://kubernetes.default.svc
    namespace: staging
  syncPolicy:
    automated:
      prune: true      # delete removed resources
      selfHeal: true   # revert manual changes
    syncOptions:
      - CreateNamespace=true
EOF

echo ""
echo "[ KUSTOMIZE STRUCTURE ]"
echo "  apps/my-app/"
echo "  ├── base/"
echo "  │   ├── deployment.yaml"
echo "  │   ├── service.yaml"
echo "  │   ├── configmap.yaml"
echo "  │   └── kustomization.yaml"
echo "  └── overlays/"
echo "      ├── staging/"
echo "      │   └── kustomization.yaml  ← patches base"
echo "      └── production/"
echo "          └── kustomization.yaml  ← patches base"

echo ""
echo "[ ARGOCD CLI REFERENCE ]"
echo "  argocd login localhost:8443 --insecure"
echo "  argocd app list"
echo "  argocd app get APP_NAME"
echo "  argocd app sync APP_NAME"
echo "  argocd app sync APP_NAME --prune"
echo "  argocd app wait APP_NAME --timeout 120"
echo "  argocd app history APP_NAME"
echo "  argocd app rollback APP_NAME ID"
echo "  argocd app delete APP_NAME"

echo ""
echo "[ SYNC STATUS ]"
echo "  Synced     = cluster matches Git ✅"
echo "  OutOfSync  = cluster differs from Git ⚠️"
echo ""
echo "[ HEALTH STATUS ]"
echo "  Healthy    = all pods running ✅"
echo "  Progressing= updating 🔄"
echo "  Degraded   = something failing ❌"
echo "  Missing    = not deployed yet"

echo ""
echo "[ GITOPS REPO STRUCTURE ]"
echo "  gitops-repo/"
echo "  ├── apps/                ← app manifests"
echo "  │   └── my-app/"
echo "  │       ├── base/"
echo "  │       └── overlays/"
echo "  │           ├── staging/"
echo "  │           └── production/"
echo "  └── argocd/              ← ArgoCD Applications"
echo "      └── applications/"
echo "          ├── app-of-apps.yaml"
echo "          ├── my-app-staging.yaml"
echo "          └── my-app-production.yaml"

echo ""
echo "[ FILES CREATED TODAY ]"
find ~/DevOps-journey/05-cicd/practices/day49-practice \
    -name "*.yaml" -o -name "*.sh" 2>/dev/null | sort

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
