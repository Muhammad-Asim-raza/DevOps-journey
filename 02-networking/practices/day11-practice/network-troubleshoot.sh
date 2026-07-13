#!/bin/bash
# ================================================
# network-troubleshoot.sh
# Step by Step Network Troubleshooter
# Author: Asim Raza
# Day 11 of DevOps Journey
# ================================================

TARGET=${1:-"google.com"}

echo "============================================"
echo "   NETWORK TROUBLESHOOTER"
echo "   Target: $TARGET"
echo "   Generated: $(date)"
echo "============================================"

ISSUES=0

echo ""
echo "[ STEP 1: Check network interface ]"
if ip link show | grep -q "state UP"; then
    echo "✅ Network interface is UP"
else
    echo "❌ Network interface is DOWN"
    echo "   Fix: sudo ip link set eth0 up"
    ISSUES=$((ISSUES + 1))
fi

echo ""
echo "[ STEP 2: Check IP address assigned ]"
MY_IP=$(hostname -I | awk '{print $1}')
if [ -n "$MY_IP" ]; then
    echo "✅ IP address assigned: $MY_IP"
else
    echo "❌ No IP address assigned"
    echo "   Fix: sudo dhclient eth0"
    ISSUES=$((ISSUES + 1))
fi

echo ""
echo "[ STEP 3: Check default gateway ]"
GATEWAY=$(ip route | grep default | awk '{print $3}')
if [ -n "$GATEWAY" ]; then
    echo "✅ Default gateway: $GATEWAY"
else
    echo "❌ No default gateway"
    echo "   Fix: sudo ip route add default via <gateway-ip>"
    ISSUES=$((ISSUES + 1))
fi

echo ""
echo "[ STEP 4: Ping gateway ]"
if [ -n "$GATEWAY" ]; then
    if ping -c 2 -W 2 $GATEWAY > /dev/null 2>&1; then
        echo "✅ Gateway is reachable"
    else
        echo "❌ Cannot reach gateway: $GATEWAY"
        echo "   Check: physical connection cable WiFi"
        ISSUES=$((ISSUES + 1))
    fi
fi

echo ""
echo "[ STEP 5: Ping external IP ]"
if ping -c 2 -W 2 8.8.8.8 > /dev/null 2>&1; then
    echo "✅ External IP 8.8.8.8 is reachable"
    echo "   Internet connection is working"
else
    echo "❌ Cannot reach 8.8.8.8"
    echo "   Check: ISP connection firewall rules"
    ISSUES=$((ISSUES + 1))
fi

echo ""
echo "[ STEP 6: Test DNS resolution ]"
IP=$(dig +short $TARGET | head -1)
if [ -n "$IP" ]; then
    echo "✅ DNS resolved: $TARGET → $IP"
else
    echo "❌ DNS resolution failed for $TARGET"
    echo "   Fix: Try dig @8.8.8.8 $TARGET"
    echo "   Fix: Check /etc/resolv.conf"
    echo "   Fix: sudo systemctl restart systemd-resolved"
    ISSUES=$((ISSUES + 1))
fi

echo ""
echo "[ STEP 7: Test HTTP connectivity ]"
STATUS=$(curl -o /dev/null -s -w "%{http_code}" --max-time 5 https://$TARGET 2>/dev/null)
if [ "$STATUS" = "200" ] || [ "$STATUS" = "301" ] || [ "$STATUS" = "302" ]; then
    echo "✅ HTTP connection successful: HTTP $STATUS"
else
    echo "❌ HTTP connection failed: HTTP $STATUS"
    echo "   Check: firewall port 80 and 443"
    ISSUES=$((ISSUES + 1))
fi

echo ""
echo "[ STEP 8: Check ports ]"
echo "Open listening ports on this machine:"
ss -tlnp | grep LISTEN | awk '{print "  Port:", $4}'

echo ""
echo "============================================"
if [ $ISSUES -eq 0 ]; then
    echo "   ✅ ALL CHECKS PASSED - Network is healthy"
else
    echo "   ❌ FOUND $ISSUES ISSUES - Check above for fixes"
fi
echo "============================================"
