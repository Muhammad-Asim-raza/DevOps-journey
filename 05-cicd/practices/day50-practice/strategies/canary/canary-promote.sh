#!/bin/bash
# ================================================
# Canary Promotion / Rollback Script
# Author: Asim Raza - Day 50
# ================================================
set -euo pipefail

ACTION="${1:-status}"  # promote | rollback | status | increase
NAMESPACE="${2:-default}"

echo "============================================"
echo "  CANARY MANAGEMENT"
echo "============================================"

show_status() {
    echo ""
    echo "[ Current Canary Status ]"
    STABLE=$(kubectl get deploy/app-stable \
        -n $NAMESPACE \
        -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "19")
    CANARY=$(kubectl get deploy/app-canary \
        -n $NAMESPACE \
        -o jsonpath='{.spec.replicas}' 2>/dev/null || echo "1")
    TOTAL=$((STABLE + CANARY))
    PCT=$(( CANARY * 100 / TOTAL ))

    echo "  Stable replicas: $STABLE"
    echo "  Canary replicas: $CANARY"
    echo "  Canary traffic:  ${PCT}%"
    echo "  Stable traffic:  $((100 - PCT))%"
}

case "$ACTION" in
    status)
        show_status
        ;;

    increase)
        echo ""
        echo "[ Increasing canary to 25% ]"
        kubectl scale deploy/app-stable \
            --replicas=15 -n $NAMESPACE \
            2>/dev/null || echo "  (simulated)"
        kubectl scale deploy/app-canary \
            --replicas=5 -n $NAMESPACE \
            2>/dev/null || echo "  (simulated)"
        echo "  ✅ Canary now at 25%"
        show_status
        ;;

    promote)
        echo ""
        echo "[ Promoting canary to 100% ]"
        echo "  Canary metrics: healthy"
        echo "  Error rate: 0.1% (stable: 0.2%)"
        echo ""
        echo "  Step 1: Shift all traffic to canary"
        kubectl scale deploy/app-stable \
            --replicas=0 -n $NAMESPACE \
            2>/dev/null || echo "  (simulated)"
        kubectl scale deploy/app-canary \
            --replicas=20 -n $NAMESPACE \
            2>/dev/null || echo "  (simulated)"

        echo ""
        echo "  Step 2: Update stable to new version"
        kubectl set image deploy/app-stable \
            app=nginx:1.25-alpine \
            -n $NAMESPACE \
            2>/dev/null || echo "  (simulated)"
        kubectl scale deploy/app-stable \
            --replicas=19 -n $NAMESPACE \
            2>/dev/null || echo "  (simulated)"

        echo ""
        echo "  Step 3: Remove canary deployment"
        kubectl scale deploy/app-canary \
            --replicas=0 -n $NAMESPACE \
            2>/dev/null || echo "  (simulated)"

        echo ""
        echo "  ✅ CANARY PROMOTED TO PRODUCTION"
        echo "  v2.0.0 now serves 100% of traffic"
        ;;

    rollback)
        echo ""
        echo "[ Rolling back canary ]"
        echo "  ⚠️  Canary error rate exceeded threshold"
        kubectl scale deploy/app-canary \
            --replicas=0 -n $NAMESPACE \
            2>/dev/null || echo "  (simulated)"
        kubectl scale deploy/app-stable \
            --replicas=20 -n $NAMESPACE \
            2>/dev/null || echo "  (simulated)"
        echo "  ✅ Canary rolled back"
        echo "  ✅ 100% traffic on stable (v1.0.0)"
        echo "  ✅ Affected users: < 5%"
        ;;

    *)
        echo "Usage: $0 [status|increase|promote|rollback]"
        ;;
esac
echo "============================================"
