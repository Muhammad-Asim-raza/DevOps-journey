#!/bin/bash
# ================================================
# network-info.sh
# Network Information and Status Report
# Author: Asim Raza
# Day 11 of DevOps Journey
# ================================================

echo "============================================"
echo "   NETWORK INFORMATION REPORT"
echo "   Generated: $(date)"
echo "============================================"

echo ""
echo "[ NETWORK INTERFACES ]"
ip addr show | grep -E "^[0-9]|inet " | \
awk '/^[0-9]/{iface=$2} /inet /{print iface, $2}'

echo ""
echo "[ IP ADDRESSES ]"
echo "Private IP: $(hostname -I | awk '{print $1}')"
echo "Public IP:  $(curl -s https://ifconfig.me 2>/dev/null || echo 'Not available')"

echo ""
echo "[ DEFAULT GATEWAY ]"
ip route | grep default

echo ""
echo "[ DNS SERVERS ]"
cat /etc/resolv.conf | grep nameserver

echo ""
echo "[ LISTENING PORTS ]"
ss -tlnp | grep LISTEN | awk '{print $4, $6}' | \
while read port process; do
    echo "  Port: $port  Process: $process"
done

echo ""
echo "[ CONNECTIVITY TESTS ]"
for HOST in google.com github.com 8.8.8.8; do
    if ping -c 1 -W 2 $HOST > /dev/null 2>&1; then
        echo "  ✅ $HOST = reachable"
    else
        echo "  ❌ $HOST = unreachable"
    fi
done

echo ""
echo "[ HTTP CONNECTIVITY ]"
for URL in https://google.com https://github.com; do
    STATUS=$(curl -o /dev/null -s -w "%{http_code}" --max-time 5 $URL)
    if [ "$STATUS" = "200" ] || [ "$STATUS" = "301" ] || [ "$STATUS" = "302" ]; then
        echo "  ✅ $URL = HTTP $STATUS"
    else
        echo "  ❌ $URL = HTTP $STATUS"
    fi
done

echo ""
echo "[ DNS RESOLUTION ]"
for DOMAIN in google.com github.com; do
    IP=$(dig +short $DOMAIN | head -1)
    if [ -n "$IP" ]; then
        echo "  ✅ $DOMAIN → $IP"
    else
        echo "  ❌ $DOMAIN → DNS resolution failed"
    fi
done

echo ""
echo "============================================"
echo "   NETWORK REPORT COMPLETE"
echo "============================================"
