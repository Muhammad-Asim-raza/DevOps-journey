#!/bin/bash
# ================================================
# monitor.sh
# Infrastructure Health Monitor
# DevOps Journey - Networking Phase Project
# Author: Asim Raza - Day 18
# ================================================

PROJECT_DIR="$HOME/DevOps-journey/02-networking/project/networking-project"
LOG_FILE="$PROJECT_DIR/logs/monitor.log"

mkdir -p "$PROJECT_DIR/logs"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
HEALTHY=0
UNHEALTHY=0

echo "============================================"
echo "   INFRASTRUCTURE HEALTH MONITOR"
echo "   Time: $TIMESTAMP"
echo "============================================"

# ── Function to check service ──
check_service() {
    local NAME=$1
    local URL=$2
    local EXPECTED=$3

    RESPONSE=$(curl -k -s -o /dev/null \
        -w "%{http_code}" \
        --max-time 3 "$URL" 2>/dev/null)

    if [ "$RESPONSE" = "$EXPECTED" ]; then
        echo "  ✅ $NAME = HTTP $RESPONSE"
        HEALTHY=$((HEALTHY + 1))
        echo "$TIMESTAMP | HEALTHY | $NAME" >> "$LOG_FILE"
    else
        echo "  ❌ $NAME = HTTP $RESPONSE (expected $EXPECTED)"
        UNHEALTHY=$((UNHEALTHY + 1))
        echo "$TIMESTAMP | UNHEALTHY | $NAME | got $RESPONSE" >> "$LOG_FILE"
    fi
}

# ── Check Backend Apps ──
echo ""
echo "[ BACKEND APPLICATIONS ]"
check_service "App-1 (port 3001)" \
    "http://localhost:3001/health" "200"
check_service "App-2 (port 3002)" \
    "http://localhost:3002/health" "200"
check_service "App-3 (port 3003)" \
    "http://localhost:3003/health" "200"

# ── Check nginx ──
echo ""
echo "[ NGINX LOAD BALANCER ]"
check_service "nginx HTTP→HTTPS redirect" \
    "http://localhost:8080" "301"
check_service "nginx HTTPS" \
    "https://localhost:8443/nginx-health" "200"

# ── Check Load Balancing ──
echo ""
echo "[ LOAD BALANCING TEST ]"
echo "  Sending 6 requests to verify distribution:"
declare -A SERVER_COUNT
for i in {1..6}; do
    SERVER=$(curl -k -s \
        "https://localhost:8443/" \
        2>/dev/null | \
        python3 -c "import sys,json; \
        d=json.load(sys.stdin); \
        print(d.get('server','unknown'))" \
        2>/dev/null)
    SERVER_COUNT[$SERVER]=$((${SERVER_COUNT[$SERVER]:-0} + 1))
done

for SERVER in "${!SERVER_COUNT[@]}"; do
    echo "  $SERVER: ${SERVER_COUNT[$SERVER]} requests"
done

# ── Check System Resources ──
echo ""
echo "[ SYSTEM RESOURCES ]"
CPU=$(top -bn1 | grep "Cpu(s)" | \
    awk '{print $2}' | cut -d. -f1)
RAM=$(free | awk '/^Mem:/ \
    {printf "%.0f", $3/$2 * 100}')
DISK=$(df / | tail -1 | \
    awk '{print $5}' | tr -d '%')

echo "  CPU Usage : ${CPU}%"
echo "  RAM Usage : ${RAM}%"
echo "  Disk Usage: ${DISK}%"

# Alerts
[ "$DISK" -gt 80 ] && \
    echo "  ⚠️  WARNING: Disk above 80%!"
[ "$RAM" -gt 90 ] && \
    echo "  ⚠️  WARNING: RAM above 90%!"

# ── Check Security ──
echo ""
echo "[ SECURITY STATUS ]"

# fail2ban
if sudo systemctl is-active --quiet fail2ban; then
    BANNED=$(sudo fail2ban-client status sshd \
        2>/dev/null | grep "Currently banned" | \
        awk '{print $NF}')
    echo "  ✅ fail2ban active (${BANNED:-0} IPs banned)"
else
    echo "  ❌ fail2ban not running!"
fi

# Firewall
if sudo ufw status | grep -q "active"; then
    echo "  ✅ Firewall (ufw) active"
else
    echo "  ⚠️  Firewall not active"
fi

# ── Summary ──
echo ""
echo "============================================"
echo "   SUMMARY: $HEALTHY healthy, $UNHEALTHY unhealthy"
if [ $UNHEALTHY -eq 0 ]; then
    echo "   STATUS: ✅ ALL SYSTEMS OPERATIONAL"
else
    echo "   STATUS: ❌ $UNHEALTHY SERVICES DOWN"
fi
echo "============================================"
