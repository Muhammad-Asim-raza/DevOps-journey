#!/bin/bash
# ================================================
# Recreate Deployment Script
# Author: Asim Raza - Day 50
# ================================================
set -euo pipefail

IMAGE="${1:-nginx:alpine}"
APP_NAME="${2:-app-recreate}"
NAMESPACE="${3:-default}"

echo "=== RECREATE DEPLOYMENT ==="
echo "Image: $IMAGE"
echo "App: $APP_NAME"
echo "Strategy: Recreate (DOWNTIME EXPECTED)"
echo ""

# Record start time
START=$(date +%s)

echo "[ Step 1 ] Stopping ALL current pods..."
kubectl scale deployment/$APP_NAME \
    --replicas=0 \
    -n $NAMESPACE 2>/dev/null || \
    echo "  (no existing deployment)"

echo "[ Step 2 ] Waiting for pods to terminate..."
kubectl rollout status deployment/$APP_NAME \
    -n $NAMESPACE \
    --timeout=60s 2>/dev/null || true

echo ""
echo "  ⚠️  DOWNTIME IN PROGRESS"
DOWNTIME_START=$(date +%T)
echo "  Downtime started: $DOWNTIME_START"

echo ""
echo "[ Step 3 ] Deploying new version..."
kubectl set image deployment/$APP_NAME \
    app=$IMAGE \
    -n $NAMESPACE 2>/dev/null || \
    kubectl apply -f strategies/recreate/deployment.yaml \
    -n $NAMESPACE 2>/dev/null || \
    echo "  (simulated in demo mode)"

echo "[ Step 4 ] Starting new pods..."
kubectl scale deployment/$APP_NAME \
    --replicas=3 \
    -n $NAMESPACE 2>/dev/null || true

sleep 2

END=$(date +%s)
DURATION=$((END - START))

echo ""
echo "  ✅ DOWNTIME ENDED"
echo "  Duration: ~${DURATION} seconds"
echo ""
echo "=== RECREATE COMPLETE ==="
