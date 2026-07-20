#!/bin/bash
# ================================================
# network-monitor.sh
# Complete Network Health Monitor
# Author: Asim Raza
# Day 14 of DevOps Journey
# Checks all network layers and services
# ================================================

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="/tmp/network-monitor.log"
ALERT_COUNT=0

echo "============================================"
echo "   COMPLETE NETWORK HEALTH MONITOR"
echo "   Generated: $TIMESTAMP"
echo "   Server: $(hostname)"
echo "============================================"

# ── LAYER 1/2: PHYSICAL/DATA LINK ──
echo ""
echo "[ LAYER 1/2: NETWORK INTERFACES ]"
INTERFACES=$(ip link show | grep "state UP" | awk '{print $2}' | tr -d ':')
if [ -n "$INTERFACES" ]; then
    for IFACE in $INTERFACES; do
        echo "  ✅ Interface $IFACE is UP"
    done
else
    echo "  ❌ No active network interfaces found"
    ALERT_COUNT=$((ALERT_COUNT + 1))
fi

# ── LAYER 3: NETWORK ──
echo ""
echo "[ LAYER 3: IP AND ROUTING ]"
MY_IP=$(hostname -I | awk '{print $1}')
if [ -n "$MY_IP" ]; then
    echo "  ✅ IP Address: $MY_IP"
else
    echo "  ❌ No IP address assigned"
    ALERT_COUNT=$((ALERT_COUNT + 1))
fi

GATEWAY=$(ip route | grep default | awk '{print $3}' | head -1)
if [ -n "$GATEWAY" ]; then
    if ping -c 1 -W 2 $GATEWAY > /dev/null 2>&1; then
        echo "  ✅ Gateway $GATEWAY is reachable"
    else
        echo "  ❌ Gateway $GATEWAY is unreachable"
        ALERT_COUNT=$((ALERT_COUNT + 1))
    fi
fi

# ── LAYER 4: TRANSPORT ──
echo ""
echo "[ LAYER 4: CONNECTIVITY TESTS ]"
for TARGET in "8.8.8.8" "1.1.1.1"; do
    if ping -c 1 -W 2 $TARGET > /dev/null 2>&1; then
        RTT=$(ping -c 3 -W 2 $TARGET 2>/dev/null | \
            grep rtt | awk -F'/' '{print $5}' | cut -d. -f1)
        echo "  ✅ $TARGET reachable (avg ${RTT}ms)"
        if [ -n "$RTT" ] && [ "$RTT" -gt 200 ]; then
            echo "  ⚠️  High latency: ${RTT}ms"
        fi
    else
        echo "  ❌ $TARGET unreachable"
        ALERT_COUNT=$((ALERT_COUNT + 1))
    fi
done

# ── LAYER 7: APPLICATION ──
echo ""
echo "[ LAYER 7: DNS RESOLUTION ]"
for DOMAIN in google.com github.com; do
    IP=$(dig +short $DOMAIN 2>/dev/null | head -1)
    if [ -n "$IP" ]; then
        echo "  ✅ $DOMAIN → $IP"
    else
        echo "  ❌ $DOMAIN DNS resolution failed"
        ALERT_COUNT=$((ALERT_COUNT + 1))
    fi
done

# ── HTTP SERVICES ──
echo ""
echo "[ HTTP/HTTPS CONNECTIVITY ]"
for URL in "http://google.com" "https://github.com"; do
    STATUS=$(curl -o /dev/null -s -w "%{http_code}" \
             --max-time 5 $URL 2>/dev/null)
    RESPONSE_TIME=$(curl -o /dev/null -s \
                   -w "%{time_total}" \
                   --max-time 5 $URL 2>/dev/null)
    if [ "$STATUS" = "200" ] || [ "$STATUS" = "301" ] || \
       [ "$STATUS" = "302" ]; then
        echo "  ✅ $URL = HTTP $STATUS (${RESPONSE_TIME}s)"
    else
        echo "  ❌ $URL = HTTP $STATUS"
        ALERT_COUNT=$((ALERT_COUNT + 1))
    fi
done

# ── LOCAL SERVICES ──
echo ""
echo "[ LOCAL SERVICES ]"
SERVICES=("nginx:80" "ssh:22")
for SERVICE_PORT in "${SERVICES[@]}"; do
    SERVICE=$(echo $SERVICE_PORT | cut -d: -f1)
    PORT=$(echo $SERVICE_PORT | cut -d: -f2)
    if ss -tlnp | grep -q ":$PORT "; then
        echo "  ✅ $SERVICE listening on port $PORT"
    else
        echo "  ⚠️  $SERVICE not listening on port $PORT"
    fi
done

# ── BANDWIDTH TEST ──
echo ""
echo "[ DOWNLOAD SPEED TEST ]"
START=$(date +%s%N)
curl -s -o /dev/null \
     "https://httpbin.org/bytes/1000000" 2>/dev/null
END=$(date +%s%N)
ELAPSED=$(( (END - START) / 1000000 ))
if [ $ELAPSED -gt 0 ]; then
    SPEED=$(echo "scale=2; 8 / ($ELAPSED / 1000)" | bc 2>/dev/null)
    echo "  Downloaded 1MB in ${ELAPSED}ms (~${SPEED} Mbps)"
else
    echo "  Speed test skipped"
fi

# ── CONNECTION SUMMARY ──
echo ""
echo "[ CONNECTION SUMMARY ]"
ss -s | grep -E "TCP:|UDP:" | while read line; do
    echo "  $line"
done

# ── LOG TO FILE ──
echo "$TIMESTAMP - Alerts: $ALERT_COUNT" >> $LOG_FILE

# ── FINAL SUMMARY ──
echo ""
echo "============================================"
if [ $ALERT_COUNT -eq 0 ]; then
    echo "   ✅ ALL CHECKS PASSED - Network Healthy"
elif [ $ALERT_COUNT -lt 3 ]; then
    echo "   ⚠️  $ALERT_COUNT WARNINGS - Check above"
else
    echo "   ❌ $ALERT_COUNT FAILURES - Investigate!"
fi
echo "   Log: $LOG_FILE"
echo "============================================"
