#!/bin/bash
# ================================================
# rollback.sh
# Emergency rollback script
# Author: Asim Raza - Day 45
# ================================================
set -euo pipefail

APP_NAME="${1:-devops-platform}"
ROLLBACK_TAG="${2:-}"

echo "================================================"
echo "  🚨 ROLLBACK: ${APP_NAME}"
echo "================================================"

if [ -z "${ROLLBACK_TAG}" ]; then
    echo "Usage: $0 APP_NAME IMAGE_TAG"
    echo "Example: $0 myapp myapp:sha-abc1234"
    exit 1
fi

echo "Rolling back to: ${ROLLBACK_TAG}"
echo "Started: $(date -u)"

# Pull rollback image
docker pull "${ROLLBACK_TAG}"

# Replace running container
docker rm -f "${APP_NAME}" 2>/dev/null || true
docker run -d \
    --name "${APP_NAME}" \
    --restart unless-stopped \
    -p 8000:8000 \
    "${ROLLBACK_TAG}"

sleep 5

# Verify
HTTP=$(curl -s -o /dev/null \
    -w "%{http_code}" \
    http://localhost:8000/health \
    2>/dev/null || echo "000")

if [ "${HTTP}" = "200" ]; then
    echo "✅ ROLLBACK SUCCESSFUL"
    echo "Running: ${ROLLBACK_TAG}"
else
    echo "❌ ROLLBACK ALSO FAILED (HTTP: ${HTTP})"
    echo "Manual intervention required!"
    exit 1
fi
