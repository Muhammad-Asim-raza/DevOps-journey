# Dockerfile - DevOps Platform API
# Day 38 - Docker Phase Project
# Author: Asim Raza
# Security: non-root, read-only-compatible
# Build: multi-stage
# ================================================

# syntax=docker/dockerfile:1

# ── Stage 1: Test Runner ──
FROM python:3.11-slim AS tester

WORKDIR /test

COPY src/ .

# Python syntax validation
RUN python3 - <<'PY'
import ast
import sys

try:
    with open("app.py") as f:
        ast.parse(f.read())

    print("Syntax check passed")

except SyntaxError as e:
    print(f"Syntax error: {e}")
    sys.exit(1)
PY

# Python compilation validation
RUN python3 -m py_compile app.py && \
    echo "Compilation check passed"


# ── Stage 2: Production ──
FROM python:3.11-slim AS production

LABEL org.opencontainers.image.title="DevOps Platform API"
LABEL org.opencontainers.image.description="Day 38 Docker Phase Project"
LABEL org.opencontainers.image.authors="Asim Raza"
LABEL org.opencontainers.image.version="1.0.0"


# Security updates
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Non-root user
RUN groupadd --gid 1001 appgroup && \
    useradd --uid 1001 \
            --gid appgroup \
            --system \
            --no-create-home \
            --shell /bin/false \
            appuser


WORKDIR /app


# Copy only application code from tester stage
COPY --from=tester /test/app.py .


# Give application user ownership
RUN chown -R appuser:appgroup /app


# Run application as non-root user
USER appuser


ENV PORT=5000 \
    APP_ENV=production \
    APP_VERSION=1.0.0 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1


EXPOSE 5000


# Container health check
HEALTHCHECK \
    --interval=15s \
    --timeout=5s \
    --start-period=20s \
    --retries=3 \
    CMD python3 -c \
    "import urllib.request; \
     urllib.request.urlopen('http://localhost:5000/health', timeout=4)" \
    || exit 1


CMD ["python3", "app.py"] 
