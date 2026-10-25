# Day 60 Exercises — AWS EKS
**Date:** Aug 17 2026
**Status:** ✅ Completed

---

## Exercise 1: EKS Architecture ✅
- [x] Control plane vs data plane
- [x] Three node types compared
- [x] eksctl installed
- [x] Production cluster config written
- [x] Multi-AZ node groups

### Proof: practices/day60-practice/exercise1-proof.txt

### Cost Awareness
Control plane: $0.10/hr = $73/month
2× m5.large: $140/month
ALWAYS delete after learning!
eksctl delete cluster --name NAME

---

## Exercise 2: IRSA ✅
- [x] Problem without IRSA explained
- [x] OIDC provider configured
- [x] IAM trust policy (OIDC condition)
- [x] K8s ServiceAccount with annotation
- [x] Deployment linked to IAM role
- [x] eksctl shortcut command

### Proof: practices/day60-practice/exercise2-proof.txt

### IRSA is EKS version of EC2 instance profile
No credentials in pods. No credentials in YAML.
OIDC token → STS → temporary creds → expired in 1hr.

---

## Exercise 3: Deploy Manifests ✅
- [x] Namespace manifests
- [x] Day 49 deployment updated for EKS
- [x] AWS ALB Ingress annotations
- [x] HPA configured
- [x] topologySpreadConstraints across AZs
- [x] ArgoCD on EKS pattern

### Proof: practices/day60-practice/exercise3-proof.txt

### Day 49 → Day 60 Connection
Day 49: wrote K8s manifests, ArgoCD GitOps
Day 60: those SAME manifests run on AWS EKS
ArgoCD installed on EKS → watches same Git repo
Full production GitOps on AWS!

---

## Exercise 4: Auto-Scaling ✅
- [x] HPA (scales pods)
- [x] Cluster Autoscaler (scales nodes)
- [x] Combined HPA + CA pattern
- [x] Fargate alternative
- [x] Scale out vs scale in cooldowns

### Proof: practices/day60-practice/exercise4-proof.txt

---

## Key Connections (Your Journey So Far)

| Day | Concept | Connection to EKS |
|-----|---------|-------------------|
| 33 | Non-root Docker | K8s securityContext |
| 44 | Docker in CI/CD | Image pushed to ECR |
| 49 | ArgoCD GitOps | Runs on EKS |
| 52 | CI/CD pipeline | Image deployed to EKS |
| 54 | IAM roles | IRSA for pod permissions |
| 55 | VPC architecture | EKS nodes in private subnets |
| 59 | ECS concepts | Same K8s concepts, different API |

---

## Summary
All 4 exercises completed Aug 17 2026

Files created:
- eks-scripts/01-install-eksctl.sh
- eks-scripts/02-create-cluster.sh
- eks-scripts/03-irsa.sh
- eks-scripts/04-deploy-to-eks.sh
- eks-configs/cluster-config.yaml
- eks-configs/irsa-trust-policy.json
- eks-configs/irsa-permissions.json
- k8s-manifests/namespace.yaml
- k8s-manifests/service-account.yaml
- k8s-manifests/deployment-eks.yaml
- k8s-manifests/service-ingress.yaml
- eks-reference.sh

Key concepts mastered:
- EKS control plane (AWS-managed) vs data plane
- Three node types: managed, self-managed, Fargate
- eksctl for cluster lifecycle
- kubeconfig management (always check context!)
- IRSA: pods get IAM roles without stored creds
- OIDC trust policy (system:serviceaccount:NS:SA)
- ALB Ingress Controller with EKS
- HPA + Cluster Autoscaler combined
- Day 49 manifests → EKS production
- ArgoCD GitOps on EKS
- Cost awareness ($73+ per month)
