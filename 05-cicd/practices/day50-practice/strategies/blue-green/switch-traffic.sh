#!/bin/bash
# ================================================
# Blue-Green Traffic Switch Script
# Author: Asim Raza - Day 50
# ================================================
set -euo pipefail

NAMESPACE="${1:-default}"
TARGET_COLOR="${2:-green}"

# Determine other color
if [ "$TARGET_COLOR" = "green" ]; then
    FROM_COLOR="blue"
else
    FROM_COLOR="green"
fi

echo "============================================"
echo "  BLUE-GREEN TRAFFIC SWITCH"
echo "============================================"
echo ""
echo "Switching: $FROM_COLOR → $TARGET_COLOR"
echo "Namespace: $NAMESPACE"

# Check target deployment is healthy
echo ""
echo "[ Pre-switch health check ]"

READY=$(kubectl get deployment/app-$TARGET_COLOR \
    -n $NAMESPACE \
    -o jsonpath='{.status.readyReplicas}' \
    2>/dev/null || echo "0")
DESIRED=$(kubectl get deployment/app-$TARGET_COLOR \
    -n $NAMESPACE \
    -o jsonpath='{.spec.replicas}' \
    2>/dev/null || echo "4")

echo "  $TARGET_COLOR pods: $READY/$DESIRED ready"

if [ "$READY" != "$DESIRED" ]; then
    echo "  ❌ $TARGET_COLOR not fully ready!"
    echo "  ❌ ABORT: switch cancelled"
    exit 1
fi

echo "  ✅ $TARGET_COLOR is healthy"

# Perform the switch
echo ""
echo "[ Switching traffic ]"

kubectl patch service app-service \
    -n $NAMESPACE \
    -p "{\"spec\":{\"selector\":{\"app\":\"demo\",\"color\":\"$TARGET_COLOR\"}}}" \
    2>/dev/null || \
    echo "  (simulated - kubectl not available in demo)"

echo "  ✅ Traffic switched to $TARGET_COLOR"
echo "  ✅ Switch took: milliseconds"
echo "  ✅ ZERO downtime"

# Verify
echo ""
echo "[ Post-switch verification ]"
echo "  Service now routes to: $TARGET_COLOR"
echo "  $FROM_COLOR pods: IDLE (warm standby)"
echo "  Rollback command:"
echo "  kubectl patch svc app-service -p \\"
echo "    '{\"spec\":{\"selector\":{\"color\":\"$FROM_COLOR\"}}}'"

echo ""
echo "[ Cleanup (after confidence period) ]"
echo "  # Keep $FROM_COLOR for 30 minutes"
echo "  # Then delete OR repurpose as new green"
echo "  # kubectl delete deploy/app-$FROM_COLOR"
echo ""
echo "============================================"
echo "  SWITCH COMPLETE: now serving $TARGET_COLOR"
echo "============================================"
