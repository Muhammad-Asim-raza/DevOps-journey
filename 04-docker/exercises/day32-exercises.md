# Day 32 Exercises — Docker Registries
**Date:** Jul 20 2026
**Status:** ✅ Completed

---

## Exercise 1: Build Image for Registry ✅
- [x] Created production-quality Python app
- [x] Wrote Dockerfile with ARG/LABEL/HEALTHCHECK
- [x] Built with build args (version/date/commit)
- [x] Tagged with semantic version
- [x] Tested locally

### Proof
See: practices/day32-practice/exercise1-proof.txt
See: practices/day32-practice/sample-app/

### Build Command
docker build \
  --build-arg APP_VERSION=1.0.0 \
  --build-arg BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --build-arg GIT_COMMIT="$(git rev-parse --short HEAD)" \
  -t registry-demo:v1.0.0 \
  -t registry-demo:latest \
  .

---

## Exercise 2: Docker Hub Workflow ✅
- [x] Understood image naming format
- [x] Learned docker login with --password-stdin
- [x] Tagged images for Docker Hub
- [x] Learned push and pull commands
- [x] Understood tagging strategy

### Proof
See: practices/day32-practice/exercise2-proof.txt

### Commands
docker login
docker tag local-image:tag username/image:tag
docker push username/image:v1.0.0
docker push username/image --all-tags
docker pull username/image:v1.0.0

### Tagging Strategy
myapp:1.0.0    = production (use this!)
myapp:latest   = most recent (avoid in prod)
myapp:abc1234  = git SHA (fully reproducible)
myapp:staging  = environment tag

---

## Exercise 3: AWS ECR ✅
- [x] Understood ECR vs Docker Hub differences
- [x] Learned ECR authentication (IAM-based)
- [x] Wrote ecr-workflow.sh script
- [x] Created lifecycle policy JSON
- [x] Understood ECR URL format

### Proof
See: practices/day32-practice/exercise3-proof.txt
See: practices/day32-practice/ecr-workflow.sh
See: practices/day32-practice/ecr-lifecycle-policy.json

### ECR URL Format
ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/REPO:TAG

### ECR Authentication
aws ecr get-login-password --region us-east-1 |
docker login --username AWS --password-stdin REGISTRY

### Will practice for real in Phase 6 (Day 53-70)

---

## Exercise 4: Self-Hosted Registry ✅
- [x] Started registry:2 container
- [x] Pushed image to local registry
- [x] Listed repositories via API
- [x] Listed tags via API
- [x] Added authentication with htpasswd
- [x] Verified auth rejects anonymous access

### Proof
See: practices/day32-practice/exercise4-proof.txt

### Commands
docker run -d -p 5000:5000 \
  -v registry-data:/var/lib/registry \
  registry:2

docker tag myapp localhost:5000/myapp:v1.0
docker push localhost:5000/myapp:v1.0

# API endpoints:
curl localhost:5000/v2/_catalog         (repos)
curl localhost:5000/v2/myapp/tags/list  (tags)

---

## Exercise 5: Registry in CI/CD ✅
- [x] Created GitHub Actions registry workflow
- [x] Uses docker/metadata-action for auto-tagging
- [x] Uses docker/login-action for auth
- [x] Uses docker/build-push-action
- [x] Includes ECR variant (commented)
- [x] Uses GitHub Actions cache for fast builds

### Proof
See: practices/day32-practice/exercise5-proof.txt
See: .github/workflows/ci-registry-workflow.yml

### Secrets Required
DOCKERHUB_USERNAME = Docker Hub username
DOCKERHUB_TOKEN    = Access token (NOT password!)

### Auto-generated Tags
On push to main:
- latest
- abc1234 (commit SHA)

On tag v1.0.0:
- 1.0.0
- 1.0
- latest
- abc1234

---

## Registry Best Practices Summary

### Authentication
Use access tokens not passwords
Rotate tokens regularly
Use --password-stdin for scripts
Use IAM roles for ECR (no credentials)

### Tagging
Always pin versions in production
Never use :latest in kubernetes/production
Use git SHA for full reproducibility
Semantic versioning for user-facing images

### Security
Private repositories for internal images
Image scanning enabled (ECR)
Lifecycle policies to auto-delete old
Minimal permissions for push credentials

### CI/CD Pattern
Build → Tag with version+SHA → Push to registry
→ Deploy pulls specific version
→ Rollback = deploy previous version tag

---

## Summary
All 5 exercises completed on Jul 20 2026

Scripts written:
- registry-reference.sh
- ecr-workflow.sh

Files created:
- sample-app/Dockerfile
- sample-app/app.py
- ecr-lifecycle-policy.json
- ci-registry-workflow.yml

Proof files:
- exercise1-proof.txt (image build)
- exercise2-proof.txt (Docker Hub)
- exercise3-proof.txt (ECR reference)
- exercise4-proof.txt (self-hosted)
- exercise5-proof.txt (CI/CD workflow)
- script-output-registry.txt

Key concepts mastered:
- Registry types and use cases
- Image naming format for each registry
- docker login/push/pull/tag commands
- Tagging strategy for production
- ECR workflow (for Phase 6)
- Self-hosted registry:2
- Registry authentication
- CI/CD integration with registries
