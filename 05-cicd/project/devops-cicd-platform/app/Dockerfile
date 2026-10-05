# ================================================
# Dockerfile — DevOps CI/CD Platform
# Author: Asim Raza - Day 52
# Multi-stage: test → production
# Security: non-root, read-only, no secrets in image
# ================================================

# syntax=docker/dockerfile:1

# ── Stage 1: Test Runner ──────────────────────────
FROM python:3.11-slim AS tester
WORKDIR /test
COPY app/requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt --quiet

COPY app/src/ ./src/
COPY app/tests/ ./tests/

RUN python -m pytest tests/ \
    -v \
    --tb=short \
    --cov=src \
    --cov-fail-under=80 \
    --cov-report=term-missing \
    -q \
    2>&1 | tee /test-output.txt

# ── Stage 2: Production ───────────────────────────
FROM python:3.11-slim AS production

LABEL org.opencontainers.image.title="DevOps CI/CD Platform"
LABEL org.opencontainers.image.description="Phase 5 CI/CD Project"
LABEL org.opencontainers.image.authors="Asim Raza"
LABEL org.opencontainers.image.source="https://github.com/Muhammad-Asim-raza/DevOps-journey"

# Security: system updates
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Security: non-root user (Day 33 pattern)
RUN groupadd --gid 1001 appgroup && \
    useradd  --uid 1001 \
             --gid appgroup \
             --system \
             --no-create-home \
             --shell /bin/false \
             appuser

WORKDIR /app

# Copy only application (NOT tests or requirements)
COPY --from=tester /test/src/app.py .
RUN chown appuser:appgroup /app/app.py

USER appuser

# Build arguments injected by CI/CD pipeline
ARG APP_VERSION=dev
ARG GIT_COMMIT=local
ARG GIT_BRANCH=local
ARG BUILD_NUMBER=0
ARG BUILD_TOOL=docker
ARG CI_PIPELINE_ID=0
ARG REGISTRY=ghcr.io

ENV APP_VERSION=${APP_VERSION} \
    GIT_COMMIT=${GIT_COMMIT} \
    GIT_BRANCH=${GIT_BRANCH} \
    BUILD_NUMBER=${BUILD_NUMBER} \
    BUILD_TOOL=${BUILD_TOOL} \
    CI_PIPELINE_ID=${CI_PIPELINE_ID} \
    REGISTRY=${REGISTRY} \
    PORT=8000 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

EXPOSE 8000

HEALTHCHECK \
    --interval=15s \
    --timeout=5s \
    --start-period=20s \
    --retries=3 \
    CMD python3 -c \
    "import urllib.request; \
     urllib.request.urlopen( \
       'http://localhost:8000/health',timeout=4)" \
    || exit 1

STOPSIGNAL SIGTERM

CMD ["python3", "app.py"]
