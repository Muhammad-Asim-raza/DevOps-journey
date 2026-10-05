# 🚀 DevOps CI/CD Platform

> Complete CI/CD Pipeline — Phase 5 Project (Day 52 of 120)

**Author:** Asim Raza | **GitHub:** Muhammad-Asim-raza

---

## 🏗️ Pipeline Architecture

git push → Secret Scan → SAST → Lint → SCA (parallel)
↓
Tests (matrix)
↓
Build Image
↓
Trivy Scan
↓
Deploy Staging
↓
Smoke Tests
↓
[Human Approval Gate]
↓
Deploy Production


## 📦 Pipeline Stages (12 Total)

| Stage | Tool | Gate |
|-------|------|------|
| 🔐 Secret Scan | Gitleaks patterns | Fail on secrets |
| 🔍 SAST | Bandit | Warn on HIGH |
| ✨ Lint | flake8 | Warn on errors |
| 📦 SCA | pip-audit | Warn on CVEs |
| 🧪 Tests | pytest + coverage | Fail if < 80% |
| 🏗️ Build | Docker BuildKit | Fail on error |
| 🔒 Image Scan | Trivy | Warn on CRITICAL |
| 🚀 Staging | Rolling update | Auto-deploy main |
| 🔬 Smoke Tests | curl endpoints | 6 checks |
| 🌟 Production | Rolling update | Manual approval |
| 📊 Report | GitHub Summary | Always runs |

## 🔗 API Endpoints

| Endpoint | Purpose | Used By |
|----------|---------|---------|
| `GET /` | Service info | Documentation |
| `GET /health` | Liveness | Docker HEALTHCHECK |
| `GET /ready` | Readiness | K8s readinessProbe |
| `GET /live` | Liveness | K8s livenessProbe |
| `GET /metrics` | Prometheus metrics | Prometheus scrape |
| `GET /build` | Build metadata | Deployment tracking |
| `GET /status` | Runtime status | Monitoring |

## 🔒 Security Features

- ✅ Non-root user (UID 1001)
- ✅ Read-only filesystem
- ✅ Multi-stage Dockerfile (no build tools in prod)
- ✅ SAST scanning (Bandit)
- ✅ Dependency scanning (pip-audit)
- ✅ Image scanning (Trivy)
- ✅ Secret scanning (pattern matching)
- ✅ No secrets in image layers (ARG vs ENV)
- ✅ GITHUB_TOKEN for GHCR (no stored credentials)

## 🛠️ CI/CD Tools Covered

| Tool | File | Phase |
|------|------|-------|
| GitHub Actions | `.github/workflows/29-*.yml` | Primary |
| Jenkins | `jenkins/Jenkinsfile` | Enterprise |
| GitLab CI | `gitlab/.gitlab-ci.yml` | Alternative |

## 🚀 Quick Start

```bash
# Run locally
docker build -t cicd-platform:dev -f app/Dockerfile .
docker run -p 8000:8000 cicd-platform:dev

# Test
curl http://localhost:8000/health
curl http://localhost:8000/build

# Run tests
python -m pytest app/tests/ --cov=app/src -v
```

## 📊 CI/CD Phase — Skills Demonstrated

| Day | Skill | Implementation |
|-----|-------|----------------|
| 39 | CI/CD concepts | Pipeline design |
| 40 | GitHub Actions | Workflow triggers |
| 41 | Advanced workflows | Parallel jobs |
| 42 | Secrets | GITHUB_TOKEN, no stored creds |
| 43 | Test automation | pytest + coverage gate |
| 44 | Docker in CI/CD | build-push-action |
| 45 | Deploy automation | Staging→production |
| 46-47 | Jenkins | Jenkinsfile equivalent |
| 48 | GitLab CI | .gitlab-ci.yml equivalent |
| 49 | GitOps/ArgoCD | K8s manifests + overlays |
| 50 | Deploy strategies | Rolling update (zero downtime) |
| 51 | Security scanning | SAST+SCA+Image+Secret |
