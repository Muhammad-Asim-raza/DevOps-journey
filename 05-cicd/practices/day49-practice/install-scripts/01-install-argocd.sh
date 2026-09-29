#!/bin/bash
# ================================================
# 01-install-argocd.sh
# Install ArgoCD on Kubernetes (kind or minikube)
# Author: Asim Raza - Day 49
# ================================================
set -euo pipefail

echo "============================================"
echo "   ARGOCD INSTALLATION"
echo "   Day 49 - GitOps"
echo "============================================"

# ── Check prerequisites ──────────────────────────
echo ""
echo "[ Checking prerequisites ]"

check_command() {
    if command -v "$1" &>/dev/null; then
        echo "  ✅ $1 available: $(command -v $1)"
    else
        echo "  ❌ $1 NOT found"
        echo "     Install: $2"
    fi
}

check_command kubectl "curl -LO https://dl.k8s.io/release/.../kubectl"
check_command helm "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"

# ── Create namespace ─────────────────────────────
echo ""
echo "[ Creating ArgoCD namespace ]"
kubectl create namespace argocd 2>/dev/null || \
    echo "  namespace 'argocd' already exists"

# ── Install ArgoCD ───────────────────────────────
echo ""
echo "[ Installing ArgoCD v2.9.x ]"
echo "  Applying official manifests..."

kubectl apply -n argocd -f \
    https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml \
    2>/dev/null || echo "  (Would apply ArgoCD manifests in real cluster)"

echo ""
echo "[ Waiting for ArgoCD to be ready ]"
echo "  kubectl wait --for=condition=Available"
echo "    deployment/argocd-server"
echo "    -n argocd --timeout=300s"
echo ""
echo "  (Takes 2-3 minutes on first install)"

# ── Get initial password ─────────────────────────
echo ""
echo "[ Getting initial admin password ]"
echo "  kubectl -n argocd get secret argocd-initial-admin-secret \\"
echo "    -o jsonpath='{.data.password}' | base64 -d; echo"
echo ""
echo "  Username: admin"
echo "  Password: [auto-generated, change after first login]"

# ── Port-forward ArgoCD UI ───────────────────────
echo ""
echo "[ Accessing ArgoCD UI ]"
echo ""
echo "  Method 1: Port-forward (development)"
echo "  kubectl port-forward svc/argocd-server -n argocd 8443:443"
echo "  Access: https://localhost:8443"
echo ""
echo "  Method 2: NodePort service"
echo "  kubectl patch svc argocd-server -n argocd \\"
echo "    -p '{\"spec\": {\"type\": \"NodePort\"}}'"
echo ""
echo "  Method 3: LoadBalancer (cloud)"
echo "  kubectl patch svc argocd-server -n argocd \\"
echo "    -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'"

# ── Install ArgoCD CLI ───────────────────────────
echo ""
echo "[ Installing ArgoCD CLI ]"
echo ""
echo "  Linux:"
echo "  curl -sSL -o argocd-linux-amd64 \\"
echo "    https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64"
echo "  chmod +x argocd-linux-amd64"
echo "  sudo mv argocd-linux-amd64 /usr/local/bin/argocd"
echo ""
echo "  macOS:"
echo "  brew install argocd"

# ── Login via CLI ────────────────────────────────
echo ""
echo "[ ArgoCD CLI Login ]"
echo ""
echo "  argocd login localhost:8443 \\"
echo "    --username admin \\"
echo "    --password <INITIAL_PASSWORD> \\"
echo "    --insecure"
echo ""
echo "  argocd account update-password"
echo "  (change password immediately!)"

echo ""
echo "============================================"
echo "   ARGOCD INSTALLATION GUIDE COMPLETE"
echo "============================================"
