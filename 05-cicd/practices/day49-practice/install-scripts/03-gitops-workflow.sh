#!/bin/bash
# ================================================
# 03-gitops-workflow.sh
# How CI and GitOps work together
# Author: Asim Raza - Day 49
# ================================================

echo "============================================"
echo "   GITOPS CI/CD INTEGRATION WORKFLOW"
echo "============================================"

echo ""
echo "[ THE GITOPS WORKFLOW ]"
echo ""
echo "TWO REPOSITORIES:"
echo ""
echo "  1. APPLICATION REPO (source code)"
echo "     github.com/org/my-app"
echo "     Contains: src/, tests/, Dockerfile"
echo "     CI/CD: GitHub Actions"
echo ""
echo "  2. GITOPS REPO (manifests)"
echo "     github.com/org/my-app-configs"
echo "     Contains: K8s YAML, kustomization"
echo "     GitOps: ArgoCD watches this"

echo ""
echo "[ STEP BY STEP WORKFLOW ]"
echo ""
echo "Step 1: Developer pushes code"
echo "  git push origin main"
echo "  (to APPLICATION repo)"
echo ""
echo "Step 2: CI pipeline runs"
echo "  GitHub Actions:"
echo "  → tests pass"
echo "  → docker build"
echo "  → docker push myapp:sha-abc1234"
echo ""
echo "Step 3: CI updates GitOps repo"
echo "  CI pipeline runs:"
echo "  cd gitops-repo/"
echo "  kustomize edit set image \\"
echo "    myapp=myapp:sha-abc1234"
echo "  git commit -m 'Deploy sha-abc1234'"
echo "  git push"
echo "  (updates IMAGE TAG in kustomization.yaml)"
echo ""
echo "Step 4: ArgoCD detects change"
echo "  ArgoCD polls GitOps repo every 3 minutes"
echo "  OR: GitHub webhook triggers sync"
echo "  Detects: kustomization.yaml changed"
echo "  Status: OutOfSync"
echo ""
echo "Step 5: ArgoCD syncs"
echo "  Applies new image tag to cluster"
echo "  Rolling update begins"
echo "  New pods start with sha-abc1234"
echo "  Old pods terminate"
echo ""
echo "Step 6: ArgoCD verifies health"
echo "  Checks: health checks passing?"
echo "  Readiness probe: /ready = 200?"
echo "  Status: InSync + Healthy"
echo ""
echo "Step 7: Rollback if needed"
echo "  git revert HEAD  (in gitops repo)"
echo "  ArgoCD detects: image changed back"
echo "  Applies rollback automatically"
echo "  Total time: < 2 minutes"

echo ""
echo "[ CI PIPELINE GITOPS STEP ]"
echo ""
echo "  # In GitHub Actions (.github/workflows/ci.yml):"
echo '  - name: Update GitOps repo'
echo '    env:'
echo '      GITOPS_TOKEN: ${{ secrets.GITOPS_REPO_TOKEN }}'
echo '    run: |'
echo '      # Clone the GitOps repository'
echo '      git clone https://oauth2:${GITOPS_TOKEN}@github.com/org/gitops-configs.git'
echo '      cd gitops-configs'
echo ''
echo '      # Update image tag'
echo '      cd apps/my-app/overlays/staging'
echo '      kustomize edit set image \\'
echo '        myapp=myapp:${{ github.sha }}'
echo ''
echo '      # Commit and push'
echo '      git config user.email "ci@company.com"'
echo '      git config user.name "CI Bot"'
echo '      git add kustomization.yaml'
echo '      git commit -m "Deploy ${{ github.sha }}"'
echo '      git push'

echo ""
echo "[ ARGOCD CLI COMMANDS ]"
echo ""
echo "  # Login"
echo "  argocd login localhost:8443 --insecure"
echo ""
echo "  # List applications"
echo "  argocd app list"
echo ""
echo "  # Check app status"
echo "  argocd app get demo-app-staging"
echo ""
echo "  # Manual sync"
echo "  argocd app sync demo-app-staging"
echo ""
echo "  # Sync with pruning"
echo "  argocd app sync demo-app-staging --prune"
echo ""
echo "  # Wait for sync"
echo "  argocd app wait demo-app-staging --timeout 120"
echo ""
echo "  # Get sync history"
echo "  argocd app history demo-app-staging"
echo ""
echo "  # Rollback to previous"
echo "  argocd app rollback demo-app-staging 3"
echo "  (3 = history ID from 'argocd app history')"
echo ""
echo "  # Delete application"
echo "  argocd app delete demo-app-staging"

echo ""
echo "[ KEY ARGOCD CONCEPTS ]"
echo ""
echo "  Sync Status:"
echo "  Synced     = cluster matches Git"
echo "  OutOfSync  = cluster differs from Git"
echo ""
echo "  Health Status:"
echo "  Healthy    = all resources running"
echo "  Progressing= update in progress"
echo "  Degraded   = something is failing"
echo "  Missing    = resource not created yet"
echo "  Suspended  = intentionally paused"
echo ""
echo "  Sync Policy:"
echo "  Manual     = human must click Sync"
echo "  Automated  = ArgoCD syncs automatically"
echo "  + selfHeal = reverts manual changes"
echo "  + prune    = removes deleted resources"

echo ""
echo "============================================"
echo "   WORKFLOW GUIDE COMPLETE"
echo "============================================"
