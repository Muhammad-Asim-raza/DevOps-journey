#!/bin/bash
# ================================================
# lb-health-monitor.sh
# Load Balancer Health Monitor
# Simulates what a load balancer health checker does
# Author: Asim Raza
# Day 16 of DevOps Journey
# ================================================

INTERVAL=${1:-5}
CHECKS=${2:-3}

echo "============================================"
echo "   LOAD BALANCER HEALTH MONITOR"
echo "   Check interval: ${INTERVAL}s"
echo "   Checks before mark: $CHECKS"
echo "============================================"

# Define backend servers to monitor
declare -A SERVERS
SERVERS["web1"]="127.0.0.1:3000"
SERVERS["web2"]="127.0.0.1:3001"
SERVERS["api1"]="127.0.0.1:4000"
SERVERS["nginx"]="127.0.0.1:80"

declare -A SERVER_STATUS
declare -A FAIL_COUNT

# Initialize
for SERVER in "${!SERVERS[@]}"; do
    SERVER_STATUS[$SERVER]="UNKNOWN"
    FAIL_COUNT[$SERVER]=0
done

check_server() {
    local NAME=$1
    local ADDRESS=$2
    local HOST=$(echo $ADDRESS | cut -d: -f1)
    local PORT=$(echo $ADDRESS | cut -d: -f2)

    # Try TCP connection first
    if nc -zw2 $HOST $PORT 2>/dev/null; then
        # Try HTTP health check
        HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" \
                     --max-time 2 \
                     "http://$ADDRESS/health" 2>/dev/null)

        if [ "$HTTP_STATUS" = "200" ]; then
            echo "    ✅ $NAME ($ADDRESS) - HTTP 200 OK"
            SERVER_STATUS[$NAME]="HEALTHY"
            FAIL_COUNT[$NAME]=0
        elif [ -n "$HTTP_STATUS" ] && [ "$HTTP_STATUS" != "000" ]; then
            echo "    ⚠️  $NAME ($ADDRESS) - HTTP $HTTP_STATUS"
            SERVER_STATUS[$NAME]="DEGRADED"
        else
            echo "    ✅ $NAME ($ADDRESS) - TCP OK (no HTTP health endpoint)"
            SERVER_STATUS[$NAME]="HEALTHY"
            FAIL_COUNT[$NAME]=0
        fi
    else
        FAIL_COUNT[$NAME]=$((${FAIL_COUNT[$NAME]} + 1))
        if [ ${FAIL_COUNT[$NAME]} -ge $CHECKS ]; then
            echo "    ❌ $NAME ($ADDRESS) - DOWN (${FAIL_COUNT[$NAME]} failures)"
            SERVER_STATUS[$NAME]="DOWN"
        else
            echo "    ⚠️  $NAME ($ADDRESS) - FAILING (${FAIL_COUNT[$NAME]}/$CHECKS)"
        fi
    fi
}

echo ""
echo "Monitoring servers (Ctrl+C to stop)..."
echo ""

ROUND=0
while true; do
    ROUND=$((ROUND + 1))
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Health Check Round $ROUND - $TIMESTAMP"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    HEALTHY=0
    DOWN=0
    for SERVER in "${!SERVERS[@]}"; do
        check_server "$SERVER" "${SERVERS[$SERVER]}"
        if [ "${SERVER_STATUS[$SERVER]}" = "HEALTHY" ]; then
            HEALTHY=$((HEALTHY + 1))
        elif [ "${SERVER_STATUS[$SERVER]}" = "DOWN" ]; then
            DOWN=$((DOWN + 1))
        fi
    done

    echo ""
    echo "Summary: $HEALTHY healthy, $DOWN down"

    if [ $ROUND -ge 2 ]; then
        echo "Stopping after $ROUND rounds (demo mode)"
        break
    fi

    echo "Next check in ${INTERVAL}s..."
    sleep $INTERVAL
done

echo ""
echo "Final Server Status:"
for SERVER in "${!SERVERS[@]}"; do
    echo "  $SERVER: ${SERVER_STATUS[$SERVER]}"
done
