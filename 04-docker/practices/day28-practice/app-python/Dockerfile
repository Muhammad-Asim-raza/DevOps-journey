# ================================================
# Dockerfile - Python Application
# Author: Asim Raza - Day 28
# ================================================

# FROM - Base image to build upon
# Always start with a specific version tag
# Never use :latest in production Dockerfiles
# python:3.11-slim = Python 3.11 on Debian slim
# slim = stripped down OS (smaller than full)
# alternative: python:3.11-alpine (even smaller)
FROM python:3.11-slim

# LABEL - Metadata about this image
# Not required but professional practice
# Shows in docker inspect output
LABEL maintainer="Asim Raza <asim@example.com>"
LABEL version="1.0.0"
LABEL description="DevOps Python App - Day 28"
LABEL org.opencontainers.image.source="https://github.com/Muhammad-Asim-raza/DevOps-journey"

# ENV - Set environment variables
# Available when container is RUNNING
# Can be overridden with -e at docker run
ENV APP_ENV=production
ENV APP_VERSION=1.0.0
ENV PORT=8000
# Do NOT put secrets here
# Use -e or --env-file at runtime for secrets

# WORKDIR - Set working directory inside container
# All subsequent instructions run from here
# Created automatically if does not exist
# Like: cd /app (and stay there)
WORKDIR /app

# COPY - Copy files from build context to image
# COPY source destination
# source = on your machine (build context)
# destination = inside the container image
#
# Copy requirements BEFORE app code
# WHY: Docker caches layers
# If requirements.txt unchanged = cache HIT
# If app.py changed = only rebuild from COPY app.py
# This makes rebuilds FAST (see later lesson)
COPY requirements.txt .
# . = current WORKDIR = /app

# RUN - Execute command during image BUILD
# Each RUN creates a new image layer
# Combine related commands to reduce layers
# Use && to chain and \ for readability
RUN pip install --no-cache-dir -r requirements.txt
# --no-cache-dir = don't cache pip downloads in image
#                  reduces image size

# COPY app code AFTER dependencies
# Dependencies change rarely
# App code changes frequently
# This ordering maximizes cache efficiency
COPY app.py .

# EXPOSE - Document which port app listens on
# DOES NOT publish the port (that is -p at run time)
# Think of it as documentation / metadata
# docker run -p 8080:8000 to actually publish
EXPOSE 8000

# CMD - Default command when container starts
# Can be overridden at docker run:
# docker run myapp python3 different-script.py
# Use exec form (JSON array) not shell form
# Exec form: CMD ["python3", "app.py"]    ← preferred
# Shell form: CMD python3 app.py          ← avoid
# WHY exec form: signals (SIGTERM) go to app
#               shell form: signals go to shell not app
CMD ["python3", "app.py"]
