# ================================================
# Dockerfile - CI/CD Docker Demo
# Author: Asim Raza - Day 44
# Build: multi-stage, security hardened
# ================================================

# syntax=docker/dockerfile:1

# ── Stage 1: Test ──────────────────────────────
FROM python:3.11-slim AS tester

WORKDIR /test
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/
COPY tests/ ./tests/

# Tests run at BUILD TIME
# If tests fail → image does NOT build
RUN python -m pytest tests/ -v \
    --tb=short \
    2>&1 | tee test-output.txt

# ── Stage 2: Production ────────────────────────
FROM python:3.11-slim AS production

LABEL org.opencontainers.image.title="CI/CD Docker Demo"
LABEL org.opencontainers.image.description="Day 44 - Docker in GitHub Actions"
LABEL org.opencontainers.image.authors="Asim Raza"
LABEL org.opencontainers.image.source="https://github.com/Muhammad-Asim-raza/DevOps-journey"

# Security: system updates
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Security: non-root user
RUN groupadd --gid 1001 appgroup && \
    useradd  --uid 1001 \
             --gid appgroup \
             --system \
             --no-create-home \
             --shell /bin/false \
             appuser

WORKDIR /app

# Copy only app code (NOT tests)
COPY --from=tester /test/src/app.py .

RUN chown appuser:appgroup /app/app.py

USER appuser

# Build-time arguments (injected by CI/CD)
ARG APP_VERSION=dev
ARG GIT_COMMIT=local
ARG BUILD_TIME=unknown
ARG GIT_BRANCH=local

ENV APP_VERSION=${APP_VERSION} \
    GIT_COMMIT=${GIT_COMMIT} \
    BUILD_TIME=${BUILD_TIME} \
    GIT_BRANCH=${GIT_BRANCH} \
    PORT=8000 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

EXPOSE 8000

HEALTHCHECK \
    --interval=15s \
    --timeout=5s \
    --start-period=10s \
    --retries=3 \
    CMD python3 -c \
    "import urllib.request; \
     urllib.request.urlopen( \
       'http://localhost:8000/health', timeout=4)" \
    || exit 1

CMD ["python3", "app.py"]
