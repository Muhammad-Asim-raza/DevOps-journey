#!/bin/bash
# ================================================
# smoke-test.sh
# Post-deployment smoke tests
# Author: Asim Raza - Day 45
# ================================================
set -euo pipefail

BASE_URL="${1:-http://localhost:8000}"
PASSED=0
FAILED=0

check() {
    local ENDPOINT="$1"
    local EXPECTED_CODE="$2"
    local LABEL="$3"

    HTTP=$(curl -s -o /dev/null \
        -w "%{http_code}" \
        --max-time 10 \
        "${BASE_URL}${ENDPOINT}" 2>/dev/null \
        || echo "000")

    if [ "${HTTP}" = "${EXPECTED_CODE}" ]; then
        echo "  ✅ ${LABEL} (HTTP ${HTTP})"
        PASSED=$((PASSED + 1))
    else
        echo "  ❌ ${LABEL} (expected ${EXPECTED_CODE}, got ${HTTP})"
        FAILED=$((FAILED + 1))
    fi
}

echo "=== POST-DEPLOYMENT SMOKE TESTS ==="
echo "Target: ${BASE_URL}"
echo ""

check "/"        "200" "Home endpoint"
check "/health"  "200" "Health check"
check "/ready"   "200" "Readiness check"
check "/version" "200" "Version endpoint"
check "/missing" "404" "404 handling"

echo ""
echo "Results: ${PASSED} passed, ${FAILED} failed"

if [ $FAILED -gt 0 ]; then
    echo "❌ SMOKE TESTS FAILED"
    exit 1
else
    echo "✅ ALL SMOKE TESTS PASSED"
    exit 0
fi
