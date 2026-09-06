#!/bin/bash
# ================================================
# healthcheck.sh - Platform Health Verification
# Author: Asim Raza - Day 38
# ================================================

BASE="http://localhost:8600"
SCORE=0; TOTAL=0

check() {
    TOTAL=$((TOTAL+1))
    URL="$1"; LABEL="$2"; EXPECT="$3"
    HTTP=$(curl -s -o /dev/null -w "%{http_code}" \
        --max-time 5 "$URL" 2>/dev/null)
    BODY=$(curl -s --max-time 5 "$URL" 2>/dev/null)
    if [ "$HTTP" = "$EXPECT" ]; then
        echo "  ✅ $LABEL (HTTP $HTTP)"
        SCORE=$((SCORE+1))
    else
        echo "  ❌ $LABEL (expected $EXPECT, got $HTTP)"
    fi
}

echo "╔══════════════════════════════════════╗"
echo "║    PLATFORM HEALTH CHECK             ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "[ API Endpoints ]"
check "$BASE/"         "Home"        "200"
check "$BASE/health"   "Health"      "200"
check "$BASE/ready"    "Ready"       "200"
check "$BASE/live"     "Liveness"    "200"
check "$BASE/metrics"  "Metrics"     "200"
check "$BASE/info"     "Info"        "200"
check "$BASE/status"   "Status"      "200"
echo ""
echo "[ Monitoring ]"
check "http://localhost:8601/-/healthy"  "Prometheus" "200"
check "http://localhost:8602/api/health" "Grafana"    "200"
echo ""
echo "[ Summary ]"
echo "  Score: $SCORE/$TOTAL"
[ "$SCORE" -eq "$TOTAL" ] && \
    echo "  ✅ Platform fully operational" || \
    echo "  ⚠️  Some checks failed"
