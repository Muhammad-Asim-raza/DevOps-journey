# Day 44 Exercises — Docker in GitHub Actions
**Date:** Aug 1 2026
**Status:** ✅ Completed

---

## Exercise 1: Docker App Built and Tested ✅
- [x] Created Flask-like app with 4 endpoints
- [x] Wrote 6 tests covering all endpoints
- [x] Multi-stage Dockerfile (test + production)
- [x] Tests run AT BUILD TIME (Stage 1)
- [x] .dockerignore configured
- [x] Built and tested locally

### Proof: practices/day44-practice/exercise1-proof.txt
### App: practices/day44-practice/docker-app/

---

## Exercise 2: Docker Hub Build Pipeline ✅
- [x] docker/metadata-action for tags
- [x] docker/login-action for registry auth
- [x] docker/build-push-action for build+push
- [x] GHA cache (type=gha, mode=max)
- [x] Trivy security scan after build
- [x] PR: build only / main: build+push

### Proof: practices/day44-practice/exercise2-proof.txt
### Workflow: .github/workflows/20-docker-build-push.yml

### Tagging Strategy
sha-abc1234 = immutable, traceable
1.0.42      = version
latest      = main branch only

---

## Exercise 3: GHCR Push ✅
- [x] Login with GITHUB_TOKEN (no setup!)
- [x] ghcr.io registry URL
- [x] packages: write permission
- [x] Compared GHCR vs Docker Hub

### Proof: practices/day44-practice/exercise3-proof.txt
### Workflow: .github/workflows/21-ghcr-push.yml

### GHCR Auth (no secrets needed!)
- uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}

---

## Exercise 4: Multi-Platform Builds ✅
- [x] setup-qemu-action (cross-compile)
- [x] setup-buildx-action (multi-platform)
- [x] platforms: linux/amd64,linux/arm64
- [x] Understood manifest lists

### Proof: practices/day44-practice/exercise4-proof.txt
### Workflow: .github/workflows/22-multi-platform.yml

---

## Exercise 5: Complete Pipeline ✅
- [x] Test → Build → Scan → Report
- [x] Job outputs passed between stages
- [x] Dockerfile security scan
- [x] GITHUB_STEP_SUMMARY report

### Workflow: .github/workflows/23-complete-docker-pipeline.yml

---

## Key Patterns Learned

### Complete Docker Build Step
- name: Build and push
  uses: docker/build-push-action@v5
  with:
    context: ./app
    push: ${{ github.ref_name == 'main' }}
    tags: ${{ steps.meta.outputs.tags }}
    build-args: |
      APP_VERSION=${{ github.run_number }}
      GIT_COMMIT=${{ github.sha }}
    cache-from: type=gha
    cache-to: type=gha,mode=max

### Tagging: Never Use :latest in Production
:latest changes every push
Use: sha-abc1234 (immutable)
Deploy by digest: image@sha256:abc...

---

## Summary
All 5 exercises completed Aug 1 2026

Workflows: 20 21 22 23 (4 workflows)
App: docker-app/ (multi-stage Dockerfile)

Key concepts mastered:
- Docker build in GitHub Actions
- docker/metadata-action (auto-tagging)
- GHCR vs Docker Hub
- Layer caching (type=gha)
- Multi-platform (amd64 + arm64)
- Trivy scanning in pipeline
- Build args for version injection
- PR vs main branch push logic
