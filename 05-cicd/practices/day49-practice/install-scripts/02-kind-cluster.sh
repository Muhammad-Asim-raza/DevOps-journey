#!/bin/bash
# ================================================
# 02-kind-cluster.sh
# Create local Kubernetes cluster with kind
# Author: Asim Raza - Day 49
# ================================================

echo "============================================"
echo "   KIND CLUSTER SETUP FOR ARGOCD"
echo "============================================"

echo ""
echo "[ What is kind? ]"
echo "  kind = Kubernetes IN Docker"
echo "  Runs a full Kubernetes cluster inside Docker"
echo "  Perfect for: local learning, CI/CD testing"
echo "  No cloud costs, no minikube driver issues"

echo ""
echo "[ Install kind ]"
echo ""
echo "  Linux/macOS:"
echo "  curl -Lo ./kind \\"
echo "    https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64"
echo "  chmod +x ./kind"
echo "  sudo mv ./kind /usr/local/bin/kind"

echo ""
echo "[ kind cluster config for ArgoCD ]"
cat << 'EOF'
# kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30080
        hostPort: 8080
        protocol: TCP
      - containerPort: 30443
        hostPort: 8443
        protocol: TCP
  - role: worker
  - role: worker
EOF

echo ""
echo "[ Create cluster ]"
echo "  kind create cluster \\"
echo "    --name devops-journey \\"
echo "    --config kind-config.yaml"
echo ""
echo "  kind get clusters"
echo "  kubectl cluster-info --context kind-devops-journey"

echo ""
echo "[ Delete cluster when done ]"
echo "  kind delete cluster --name devops-journey"

echo ""
echo "[ Alternative: Use existing cluster ]"
echo "  Works with ANY Kubernetes cluster:"
echo "  - Local: kind, minikube, k3d, Docker Desktop K8s"
echo "  - Cloud: EKS, GKE, AKS"
echo "  - On-prem: kubeadm, RKE2, k3s"

echo ""
echo "============================================"
echo "   KIND SETUP GUIDE COMPLETE"
echo "============================================"
