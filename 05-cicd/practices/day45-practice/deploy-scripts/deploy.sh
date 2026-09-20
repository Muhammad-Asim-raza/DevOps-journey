#!/bin/bash
# ================================================
# deploy.sh
# Server-side deployment script
# Run ON the production server via SSH
# Author: Asim Raza - Day 45
# ================================================
set -euo pipefail
# set -e = exit on error
# set -u = error on undefined variable
# set -o pipefail = pipe fails if any command fails

# Arguments
APP_NAME="${1:-devops-platform}"
IMAGE_TAG="${2:-latest}"
COMPOSE_FILE="${3:-/opt/${APP_NAME}/docker-compose.yml}"
HEALTH_URL="${4:-http://localhost:8600/health}"
MAX_WAIT="${5:-60}"

echo "================================================"
echo "  DEPLOYMENT: ${APP_NAME}"
echo "  Image:      ${IMAGE_TAG}"
echo "  Time:       $(date -u)"
echo "================================================"

# Step 1: Pull new image
echo ""
echo "[1/5] Pulling image: ${IMAGE_TAG}"
docker pull "${IMAGE_TAG}" || {
    echo "❌ Failed to pull image"
    exit 1
}
echo "✅ Image pulled"

# Step 2: Store current version for rollback
echo ""
echo "[2/5] Saving rollback point"
CURRENT_IMAGE=$(docker inspect \
    --format='{{.Config.Image}}' \
    "${APP_NAME}" 2>/dev/null || echo "none")
echo "Current: ${CURRENT_IMAGE}"
echo "New: ${IMAGE_TAG}"

# Step 3: Update the service
echo ""
echo "[3/5] Updating service"
if [ -f "${COMPOSE_FILE}" ]; then
    # Update image in compose file
    sed -i "s|image:.*${APP_NAME}.*|image: ${IMAGE_TAG}|g" \
        "${COMPOSE_FILE}" 2>/dev/null || true

    # Pull and restart
    docker compose -f "${COMPOSE_FILE}" pull
    docker compose -f "${COMPOSE_FILE}" up -d \
        --no-deps \
        --remove-orphans \
        "${APP_NAME}"
else
    # Direct docker run
    docker rm -f "${APP_NAME}" 2>/dev/null || true
    docker run -d \
        --name "${APP_NAME}" \
        --restart unless-stopped \
        -p 8000:8000 \
        "${IMAGE_TAG}"
fi
echo "✅ Service updated"

# Step 4: Health check loop
echo ""
echo "[4/5] Waiting for health check"
ELAPSED=0
HEALTHY=false

while [ $ELAPSED -lt $MAX_WAIT ]; do
    HTTP_CODE=$(curl -s -o /dev/null \
        -w "%{http_code}" \
        --max-time 5 \
        "${HEALTH_URL}" 2>/dev/null || echo "000")

    if [ "${HTTP_CODE}" = "200" ]; then
        HEALTHY=true
        echo "✅ Health check passed (HTTP ${HTTP_CODE})"
        break
    fi

    echo "  Waiting... ${ELAPSED}s (HTTP ${HTTP_CODE})"
    sleep 5
    ELAPSED=$((ELAPSED + 5))
done

# Step 5: Verify or rollback
echo ""
echo "[5/5] Verifying deployment"

if $HEALTHY; then
    echo "✅ DEPLOYMENT SUCCESSFUL"
    echo "  App: ${APP_NAME}"
    echo "  Image: ${IMAGE_TAG}"
    echo "  URL: ${HEALTH_URL}"
    exit 0
else
    echo "❌ DEPLOYMENT FAILED - Health check timeout"
    echo "  Rolling back to: ${CURRENT_IMAGE}"

    if [ "${CURRENT_IMAGE}" != "none" ]; then
        docker rm -f "${APP_NAME}" 2>/dev/null || true
        docker run -d \
            --name "${APP_NAME}" \
            --restart unless-stopped \
            -p 8000:8000 \
            "${CURRENT_IMAGE}"
        echo "✅ Rolled back to: ${CURRENT_IMAGE}"
    fi

    exit 1
fi
