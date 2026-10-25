#!/bin/bash
# ================================================
# eks-reference.sh
# EKS Complete Reference
# Author: Asim Raza - Day 60
# ================================================

echo "============================================"
echo "   AWS EKS COMPLETE REFERENCE"
echo "   Author: Asim Raza - Day 60"
echo "============================================"

echo ""
echo "[ EKS ARCHITECTURE ]"
echo "  Control Plane: AWS-managed (pay $0.10/hr)"
echo "  Data Plane:    your EC2 nodes"
echo "  Node types:    Managed, Self-managed, Fargate"

echo ""
echo "[ EKSCTL COMMANDS ]"
echo "  eksctl create cluster -f cluster.yaml"
echo "  eksctl delete cluster --name NAME"
echo "  eksctl get cluster"
echo "  eksctl scale nodegroup --cluster C --name NG --nodes N"
echo "  eksctl upgrade cluster --name NAME --version 1.30"
echo "  eksctl create iamserviceaccount  ← IRSA setup"

echo ""
echo "[ KUBECTL ON EKS ]"
echo "  aws eks update-kubeconfig --name CLUSTER --region REGION"
echo "  kubectl config current-context  ← check before any command!"
echo "  kubectl get nodes"
echo "  kubectl get pods -A"
echo "  kubectl apply -f manifests/"
echo "  kubectl logs -f -l app=NAME -n NS"
echo "  kubectl exec -it POD -n NS -- /bin/sh"
echo "  kubectl top nodes / kubectl top pods"

echo ""
echo "[ IRSA PATTERN ]"
echo "  1. OIDC provider (eksctl: withOIDC: true)"
echo "  2. IAM role trust policy → OIDC + SA name"
echo "  3. K8s ServiceAccount annotation:"
echo "     eks.amazonaws.com/role-arn: arn:...role/NAME"
echo "  4. Deployment: serviceAccountName: SA_NAME"
echo "  5. SDK auto-detects → gets temp credentials"

echo ""
echo "[ AUTO-SCALING ]"
echo "  HPA: scales pods (CPU/memory/custom)"
echo "  CA:  scales nodes (when pods unschedulable)"
echo "  Together: full elastic infrastructure"

echo ""
echo "[ EKS vs ECS ]"
echo "  ECS: simpler, AWS-native, lower ops burden"
echo "  EKS: powerful, CNCF ecosystem, multi-cloud"
echo "  Fargate: both offer serverless option"
echo "  Choose ECS: small teams, AWS-only, simple apps"
echo "  Choose EKS: large teams, complex, multi-cloud"

echo ""
echo "[ COST WARNING ]"
echo "  Control plane: $0.10/hr = $73/month"
echo "  2x m5.large:   $0.19/hr = $140/month"
echo "  Total min:     ~$213/month"
echo "  DELETE when done: eksctl delete cluster --name NAME"

echo ""
echo "[ CONNECT TO DAY 49 ARGOCD ]"
echo "  Install ArgoCD on EKS cluster"
echo "  Point Application at your GitOps repo"
echo "  Day 49 manifests → auto-deploy to EKS"
echo "  Full GitOps on production Kubernetes!"

echo ""
echo "============================================"
echo "   EKS REFERENCE COMPLETE"
echo "============================================"
