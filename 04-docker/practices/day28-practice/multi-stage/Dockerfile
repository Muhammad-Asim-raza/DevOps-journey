# ================================================
# Multi-Stage Dockerfile - Python
# Author: Asim Raza - Day 28
# ================================================

# ── STAGE 1: Builder ──
# Named stage: 'builder'
# This stage installs everything including dev tools
# It will NOT be in the final image
FROM python:3.11-slim AS builder
# AS builder = name this stage 'builder'
#              can reference it later

# Install build dependencies
# These might include compilers, headers etc
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*
# --no-install-recommends = only required packages
# rm -rf /var/lib/apt/lists/* = clean apt cache
# COMBINE these to reduce layers and image size

WORKDIR /build

# Copy and install production dependencies
COPY requirements.txt .
RUN mkdir -p /install && \
    pip install --no-cache-dir \
    --prefix=/install \
    -r requirements.txt
# --prefix=/install = install packages to /install
#                    not system Python
#                    easy to copy to next stage

# Copy application
COPY app.py .

# ── STAGE 2: Test ──
# Run tests in builder context before production
# Tests use dev requirements
FROM builder AS test
# FROM builder = start from builder stage
# all packages already installed

COPY requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements-dev.txt

# Run any tests here
RUN python -c "import app; print('App imports OK')"
# In real project: RUN pytest tests/ --tb=short

# ── STAGE 3: Production ──
# Final stage: clean, minimal image
# Only what is needed to RUN (not build/test)
FROM python:3.11-slim AS production
# Fresh minimal base image
# NOTHING from builder except what we COPY

LABEL maintainer="Asim Raza"
LABEL stage="production"

# Security: create non-root user
RUN groupadd -r appgroup && \
    useradd -r -g appgroup appuser
# -r = system user (no home directory, no shell)
# -g = assign to group

# Set working directory
WORKDIR /app

# Copy ONLY installed packages from builder stage
# NOT the compiler, NOT the build tools
# JUST the pip packages our app needs
COPY --from=builder /install /usr/local
# --from=builder = copy FROM the 'builder' stage
#                  not from host machine
# /install = where we put packages in builder
# /usr/local = where Python expects them

# Copy ONLY the application code
# NOT dev requirements, NOT test files
COPY --from=builder /build/app.py .

# Change ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Environment
ENV APP_ENV=production
EXPOSE 8000

# Health check built into image
HEALTHCHECK --interval=30s \
            --timeout=3s \
            --start-period=5s \
            --retries=3 \
    CMD python3 -c \
    "import urllib.request; \
     urllib.request.urlopen('http://localhost:8000/health')" \
    || exit 1
# --interval=30s = check every 30 seconds
# --timeout=3s = fail if takes more than 3s
# --start-period=5s = wait 5s after start
#                     before first check
# --retries=3 = mark unhealthy after 3 failures

CMD ["python3", "app.py"]
