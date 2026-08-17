# ================================================
# Dockerfile - Node.js Application
# Author: Asim Raza - Day 28
# ================================================

# Use Node.js LTS (Long Term Support) version
# -alpine = Alpine Linux base = very small image
FROM node:18-alpine

# Set metadata
LABEL maintainer="Asim Raza"
LABEL version="1.0.0"

# Create non-root user for security
# NEVER run Node apps as root in production
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup
# addgroup -S = add system group (no login)
# adduser -S = add system user (no login)
# -G appgroup = add to appgroup

# Set working directory
WORKDIR /app

# Copy package files FIRST (layer caching trick)
# package.json and package-lock.json rarely change
COPY package*.json ./
# package*.json matches:
# package.json AND package-lock.json (if exists)
# ./ = current WORKDIR

# Install dependencies
RUN npm install --production
# --production = skip devDependencies
#               only install what production needs
#               smaller image

# Copy application code AFTER dependencies
# Code changes more often than dependencies
# Keeps npm install layer cached
COPY server.js .

# Set correct ownership for security
# Give appuser ownership of app files
RUN chown -R appuser:appgroup /app

# Switch to non-root user
# All subsequent operations run as appuser
USER appuser

# Document port
EXPOSE 3000

# Set default environment
ENV NODE_ENV=production
ENV PORT=3000

# Use exec form for proper signal handling
CMD ["node", "server.js"]
