# Day 34 Exercises — Multi-Stage Builds Optimization
**Date:** Jul 22 2026
**Status:** ✅ Completed

---

## Exercise 1: Python Multi-Stage ✅
- [x] Built baseline (1GB+ image)
- [x] Built 4-stage optimized Dockerfile
- [x] Stage 1: dependency-builder
- [x] Stage 2: test-runner
- [x] Stage 3: security-check
- [x] Stage 4: production
- [x] Compared sizes
- [x] Verified same functionality

### Proof
See: practices/day34-practice/exercise1-proof.txt
See: practices/day34-practice/python-optimized/

### Size Reduction
python:3.11 baseline = 1GB+
python:3.11-slim optimized = ~180MB
Reduction: ~82%

### Key Pattern
FROM python:3.11-slim AS dependency-builder
RUN pip install --prefix=/install -r requirements.txt

FROM python:3.11-slim AS production
COPY --from=dependency-builder /install /usr/local
COPY app.py .
(compiler and build tools NOT in production)

---

## Exercise 2: Node.js Multi-Stage ✅
- [x] Built baseline Node.js image
- [x] Built optimized with 4 stages
- [x] Used dumb-init for signal handling
- [x] Excluded devDependencies from production
- [x] Used pre-existing 'node' user

### Proof
See: practices/day34-practice/exercise2-proof.txt
See: practices/day34-practice/node-optimized/

### Stages
deps        = install all dependencies
builder     = compile/verify
tester      = run tests
production  = minimal runtime image

### Key Pattern
FROM node:18-alpine AS deps
RUN npm install --frozen-lockfile

FROM node:18-alpine AS production
USER node
COPY --from=deps /app/node_modules ./
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "server.js"]

---

## Exercise 3: BuildKit Features ✅
- [x] Enabled DOCKER_BUILDKIT=1
- [x] Used cache mounts for pip
- [x] Used heredoc syntax
- [x] Built parallel stages
- [x] Verified cache mount speedup

### Proof
See: practices/day34-practice/exercise3-proof.txt
See: practices/day34-practice/buildkit-demo/

### Cache Mount (most important!)
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

Without: every build downloads all packages
With: first build downloads, all after use cache
Result: 30 seconds → 3 seconds

### Parallel Stages
BuildKit automatically detects independent stages
Runs them simultaneously (parallel)
Significantly faster than sequential

---

## Multi-Stage Best Practices

### Stage Design
1. One stage per concern (build/test/security/prod)
2. Name all stages (AS name)
3. ONLY copy what production needs
4. Test stage should fail build on test failure
5. Security scan stage for CVEs

### BuildKit Must-Haves
Add to all Dockerfiles:
# syntax=docker/dockerfile:1

Cache mounts:
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

### Base Image Selection
Full image: development/debugging only
slim: production Python/Node
alpine: smallest, musl libc (test compatibility)
distroless: no shell, maximum security

### --target Flag
docker build --target test .   = run tests only
docker build --target dev .    = dev environment
docker build (no target) .     = final stage onl
---

## Summary
All 3 exercises completed on Jul 22 2026

Scripts written:
- multistage-reference.sh
- size-comparison/compare-sizes.sh

Dockerfiles created:
- python-optimized/Dockerfile.baseline
- python-optimized/Dockerfile.optimized
- node-optimized/Dockerfile.node-baseline
- node-optimized/Dockerfile.node-optimized
- buildkit-demo/Dockerfile.buildkit
- buildkit-demo/Dockerfile.parallel

Images built:
- python-baseline:v1
- python-optimized:v1
- node-baseline:v1
- node-optimized:v1
- buildkit-demo:v1
- parallel-demo:v1

Proof files:
- exercise1-proof.txt (Python multi-stage)
- exercise2-proof.txt (Node.js multi-stage)
- exercise3-proof.txt (BuildKit)
- script-output-multistage.txt

Key concepts mastered:
- WHY image size matters (cost/security)
- Multi-stage build design principles
- Stage naming and --target flag
- COPY --from between stages
- BuildKit cache mounts
- BuildKit parallel stages
- BuildKit heredoc syntax
- dumb-init for Node.js
- Size analysis and optimization
