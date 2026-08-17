# ================================================
# Production Dockerfile - Best Practices
# Author: Asim Raza - Day 28
# Uses: ARG, LABEL, HEALTHCHECK, USER, EXPOSE
# ================================================

# ARG - Build-time variables
# Available DURING docker build
# NOT available in running container
# Override with: docker build --build-arg VERSION=2.0
ARG PYTHON_VERSION=3.11
ARG APP_VERSION=1.0.0
ARG BUILD_DATE="unknown"
ARG GIT_COMMIT="unknown"

# Use ARG in FROM
FROM python:${PYTHON_VERSION}-slim
# ${PYTHON_VERSION} = uses value of ARG
# allows building with different Python versions:
# docker build --build-arg PYTHON_VERSION=3.12 .

# Re-declare ARGs after FROM
# ARGs are reset after each FROM instruction
ARG APP_VERSION=1.0.0
ARG BUILD_DATE="unknown"
ARG GIT_COMMIT="unknown"

# LABEL - Image metadata (OCI standard)
# Searchable, inspectable metadata
# Best practice: use OCI image spec labels
LABEL org.opencontainers.image.title="DevOps Production App"
LABEL org.opencontainers.image.description="Production-ready Python app"
LABEL org.opencontainers.image.version="${APP_VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.authors="Asim Raza"
LABEL org.opencontainers.image.source="https://github.com/Muhammad-Asim-raza"

# Convert build ARGs to runtime ENVs
# ARGs only exist during build
# ENVs persist in running container
ENV APP_VERSION=${APP_VERSION}
ENV BUILD_DATE=${BUILD_DATE}
ENV GIT_COMMIT=${GIT_COMMIT}
ENV APP_ENV=production
ENV PORT=8000
ENV PYTHONDONTWRITEBYTECODE=1
# PYTHONDONTWRITEBYTECODE=1 = no .pyc files
# keeps container filesystem clean
ENV PYTHONUNBUFFERED=1
# PYTHONUNBUFFERED=1 = print immediately
# without buffering (see logs in real-time)

# Install system security updates
# Best practice: always update before installing
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
# curl = needed for HEALTHCHECK
# rm -rf + apt-get clean = remove cache
# MUST be in same RUN layer
# Otherwise cache stays in previous layer

# Create non-root user and group
RUN groupadd --gid 1001 appgroup && \
    useradd --uid 1001 \
            --gid appgroup \
            --shell /bin/bash \
            --create-home \
            appuser
# --uid 1001 = specific UID (not random)
# --create-home = creates /home/appuser
# Using explicit IDs = reproducible

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY requirements.txt* ./
RUN pip install --no-cache-dir -r requirements.txt \
    2>/dev/null || echo "No requirements to install"

# Copy application code
COPY app.py .

# Set correct ownership BEFORE switching user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
# All subsequent operations run as appuser
USER appuser

# Expose documentation
EXPOSE 8000

# HEALTHCHECK - Docker monitors container health
# Docker status: healthy / unhealthy / starting
HEALTHCHECK --interval=30s \
            --timeout=5s \
            --start-period=10s \
            --retries=3 \
    CMD curl -f http://localhost:${PORT}/health \
        || exit 1
# -f = fail silently on server errors
# || exit 1 = if curl fails, exit code 1
#             tells Docker: unhealthy

# Use exec form CMD for signal handling
CMD ["python3", "-u", "app.py"]
# -u = unbuffered (real-time logs)
