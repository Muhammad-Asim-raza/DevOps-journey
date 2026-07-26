#!/bin/bash
# ================================================
# security-audit.sh
# Complete Network Security Audit Script
# Author: Asim Raza
# Day 17 of DevOps Journey
# ================================================

echo "============================================"
echo "   NETWORK SECURITY AUDIT"
echo "   Generated: $(date)"
echo "   Server: $(hostname)"
echo "============================================"

SCORE=0
TOTAL=0
ISSUES=()

check() {
    local DESC=$1
    local CMD=$2
    local EXPECTED=$3
    TOTAL=$((TOTAL + 1))

    RESULT=$(eval "$CMD" 2>/dev/null)
    if echo "$RESULT" | grep -q "$EXPECTED"; then
        echo "  ✅ PASS: $DESC"
        SCORE=$((SCORE + 1))
    else
        echo "  ❌ FAIL: $DESC"
        ISSUES+=("$DESC")
    fi
}

# ── FIREWALL CHECKS ──
echo ""
echo "[ FIREWALL SECURITY ]"

check "ufw is active" \
    "sudo ufw status" \
    "Status: active"

check "iptables has rules" \
    "sudo iptables -L INPUT -n | wc -l" \
    "[2-9][0-9]*\|[3-9]"

check "Default INPUT policy is DROP" \
    "sudo iptables -L INPUT -n | head -1" \
    "DROP"

# ── SSH SECURITY ──
echo ""
echo "[ SSH SECURITY ]"

SSH_CONFIG="/etc/ssh/sshd_config"

check "Root login disabled" \
    "grep 'PermitRootLogin' $SSH_CONFIG" \
    "PermitRootLogin no"

check "Password auth disabled" \
    "grep 'PasswordAuthentication' $SSH_CONFIG" \
    "PasswordAuthentication no"

check "SSH on port 22 (consider changing)" \
    "grep '^Port' $SSH_CONFIG || echo 'Port 22'" \
    "Port"

# ── FAIL2BAN ──
echo ""
echo "[ FAIL2BAN PROTECTION ]"

check "fail2ban installed" \
    "which fail2ban-client" \
    "fail2ban"

check "fail2ban running" \
    "sudo systemctl is-active fail2ban" \
    "active"

check "SSH jail enabled" \
    "sudo fail2ban-client status sshd 2>/dev/null" \
    "Status for the jail"

# ── EXPOSED SERVICES ──
echo ""
echo "[ EXPOSED SERVICES AUDIT ]"

echo "  Currently listening ports:"
ss -tlnp | grep LISTEN | while read line; do
    PORT=$(echo $line | awk '{print $4}' | cut -d: -f2)
    PROC=$(echo $line | awk '{print $6}')
    echo "    Port $PORT: $PROC"
done

# Check for dangerous exposed ports
for PORT in 3306 5432 6379 27017 9200; do
    if ss -tlnp | grep -q ":$PORT "; then
        EXTERNAL=$(ss -tlnp | grep ":$PORT " | \
            grep -v "127.0.0.1")
        if [ -n "$EXTERNAL" ]; then
            echo "  ❌ DANGER: Port $PORT exposed externally!"
            ISSUES+=("Port $PORT (database/cache) exposed externally")
        else
            echo "  ✅ Port $PORT only on localhost"
        fi
    fi
done

# ── FILE SECURITY ──
echo ""
echo "[ FILE SECURITY ]"

check "No world-writable files in /etc" \
    "find /etc -perm -o+w -type f 2>/dev/null | wc -l" \
    "^0$"

check "SSH directory permissions correct" \
    "stat -c '%a' ~/.ssh 2>/dev/null" \
    "700"

# ── NETWORK SECURITY ──
echo ""
echo "[ NETWORK SECURITY ]"

check "SYN cookies enabled" \
    "sysctl net.ipv4.tcp_syncookies" \
    "= 1"

check "IP forwarding disabled (not a router)" \
    "sysctl net.ipv4.ip_forward" \
    "= 0"

check "ICMP redirects disabled" \
    "sysctl net.ipv4.conf.all.accept_redirects" \
    "= 0"

# ── SSL/TLS ──
echo ""
echo "[ SSL/TLS SECURITY ]"

check "nginx has SSL config" \
    "grep -r 'ssl_protocols' /etc/nginx/ 2>/dev/null" \
    "TLSv1.2\|TLSv1.3"

check "Old TLS disabled" \
    "grep -r 'ssl_protocols' /etc/nginx/ 2>/dev/null" \
    "TLSv1.2\|TLSv1.3"

# ── FINAL SCORE ──
echo ""
echo "============================================"
echo "   SECURITY AUDIT RESULTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Score: $SCORE / $TOTAL checks passed"

PERCENTAGE=$((SCORE * 100 / TOTAL))
if [ $PERCENTAGE -ge 90 ]; then
    echo "Rating: 🏆 EXCELLENT ($PERCENTAGE%)"
elif [ $PERCENTAGE -ge 70 ]; then
    echo "Rating: ✅ GOOD ($PERCENTAGE%)"
elif [ $PERCENTAGE -ge 50 ]; then
    echo "Rating: ⚠️  NEEDS IMPROVEMENT ($PERCENTAGE%)"
else
    echo "Rating: ❌ CRITICAL ISSUES ($PERCENTAGE%)"
fi

if [ ${#ISSUES[@]} -gt 0 ]; then
    echo ""
    echo "Issues to fix:"
    for ISSUE in "${ISSUES[@]}"; do
        echo "  → $ISSUE"
    done
fi
echo "============================================"
