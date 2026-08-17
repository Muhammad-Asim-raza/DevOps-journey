# Day 28 Exercises — Dockerfile Writing & Best Practices
**Date:** Jul 16 2026
**Status:** ✅ Completed

---

## Exercise 1: First Dockerfile (Python) ✅
- [x] Created Python web app
- [x] Wrote Dockerfile with all instructions
- [x] Built image with docker build
- [x] Ran container and tested endpoints
- [x] Demonstrated layer caching

### Proof
See: practices/day28-practice/exercise1-proof.txt
See: practices/day28-practice/app-python/Dockerfile

### Instructions Used
FROM python:3.11-slim
LABEL maintainer=...
ENV APP_ENV=production
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 8000
CMD ["python3", "app.py"]

### Caching Order
COPY requirements.txt (rarely changes)
RUN pip install (cached if requirements unchanged)
COPY app.py (changes often)
= Only last step rebuilds on code change!

---

## Exercise 2: Node.js Dockerfile ✅
- [x] Created Node.js app
- [x] Built with node:18-alpine
- [x] Created non-root user with adduser
- [x] Applied correct file ownership
- [x] Verified runs as non-root

### Proof
See: practices/day28-practice/exercise2-proof.txt
See: practices/day28-practice/app-node/Dockerfile

### Security Pattern
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /app
USER appuser

---

## Exercise 3: .dockerignore ✅
- [x] Created comprehensive .dockerignore
- [x] Verified node_modules excluded
- [x] Verified .env excluded from build context
- [x] Understood impact on build speed

### Proof
See: practices/day28-practice/exercise3-proof.txt
See: practices/day28-practice/app-node/.dockerignore

### Always Ignore
node_modules/ (huge, installed by RUN npm install)
.env (SECRETS - never in image!)
.git/ (not needed)
tests/ (not in production image)
*.log (not in image)

---

## Exercise 4: Multi-Stage Builds ✅
- [x] Created 3-stage Dockerfile
- [x] Stage 1: builder (with compiler/tools)
- [x] Stage 2: test (runs tests)
- [x] Stage 3: production (clean minimal)
- [x] Verified dev tools not in production image
- [x] Compared image sizes

### Proof
See: practices/day28-practice/exercise4-proof.txt
See: practices/day28-practice/multi-stage/Dockerfile

### Multi-Stage Pattern
FROM python:3.11-slim AS builder
... install build tools, compile ...

FROM python:3.11-slim AS production
COPY --from=builder /install /usr/local
... clean minimal image ...

### Benefits
- Smaller production images
- No build tools in production
- Better security
- Faster deployments

---

## Exercise 5: Production Dockerfile ✅
- [x] Used ARG for build-time variables
- [x] Used OCI standard LABEL format
- [x] Converted ARG to ENV for runtime
- [x] Added HEALTHCHECK
- [x] Non-root user with explicit UID/GID
- [x] Built with --build-arg

### Proof
See: practices/day28-practice/exercise5-proof.txt
See: practices/day28-practice/production-app/Dockerfile

### Production Build Command
docker build \
  --build-arg APP_VERSION=1.5.0 \
  --build-arg BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --build-arg GIT_COMMIT="$(git rev-parse --short HEAD)" \
  -t myapp:v1.5.0 .

### HEALTHCHECK Format
HEALTHCHECK --interval=30s --timeout=5s \
            --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

---

## Dockerfile Best Practices Summary

### Layer Caching Optimization
Put stable layers FIRST:
1. FROM (base image)
2. RUN apt-get (system packages)
3. COPY requirements.txt
4. RUN pip install
5. COPY . . (app code - changes most)

### Security Checklist
✅ Use specific version tags (never :latest)
✅ Run as non-root user
✅ Use .dockerignore
✅ No secrets in image (use -e at runtime)
✅ Clean package manager cache in same RUN
✅ Multi-stage for production

### CMD vs ENTRYPOINT
CMD = default, overridable
ENTRYPOINT = fixed command, args from CMD
Use CMD alone for most cases

---

## Summary
All 5 exercises completed on Jul 16 2026

Scripts written:
- dockerfile-reference.sh

Dockerfiles created:
- app-python/Dockerfile (Python app)
- app-node/Dockerfile (Node.js + non-root)
- app-node/.dockerignore (exclusions)
- multi-stage/Dockerfile (3-stage build)
- production-app/Dockerfile (full best practices)

Images built:
- devops-python-app:v1.0
- devops-node-app:v1.0
- dockerignore-test:v1
- multi-stage-app:v1.0
- devops-production-app:v1.5.0

Proof files:
- exercise1-proof.txt (first Dockerfile)
- exercise2-proof.txt (Node.js)
- exercise3-proof.txt (.dockerignore)
- exercise4-proof.txt (multi-stage)
- exercise5-proof.txt (production)
- script-output-dockerfile.txt
