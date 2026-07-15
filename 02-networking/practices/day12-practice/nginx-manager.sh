#!/bin/bash
# ================================================
# nginx-manager.sh
# nginx Management and Status Tool
# Author: Asim Raza
# Day 12 of DevOps Journey
# ================================================

echo "============================================"
echo "   NGINX MANAGER"
echo "   Generated: $(date)"
echo "============================================"

echo ""
echo "[ NGINX VERSION ]"
nginx -v 2>&1

echo ""
echo "[ NGINX SERVICE STATUS ]"
sudo systemctl status nginx | grep -E "Active:|Main PID:|Tasks:"

echo ""
echo "[ ENABLED VIRTUAL HOSTS ]"
echo "Sites enabled:"
ls -la /etc/nginx/sites-enabled/

echo ""
echo "[ NGINX CONFIGURATION TEST ]"
sudo nginx -t 2>&1

echo ""
echo "[ LISTENING PORTS ]"
echo "Ports nginx is listening on:"
ss -tlnp | grep nginx

echo ""
echo "[ VIRTUAL HOST PORTS ]"
echo "Configured ports in nginx:"
grep -r "listen" /etc/nginx/sites-enabled/ | grep -v "#" | awk '{print $3}' | sort -u

echo ""
echo "[ HTTP CONNECTIVITY TESTS ]"
for PORT in 80 8081 8082 8083 8084; do
    STATUS=$(curl -o /dev/null -s -w "%{http_code}" \
             --max-time 2 http://localhost:$PORT 2>/dev/null)
    if [ "$STATUS" = "200" ] || [ "$STATUS" = "301" ]; then
        echo "  ✅ Port $PORT = HTTP $STATUS"
    else
        echo "  ⚠️  Port $PORT = HTTP $STATUS (not running or error)"
    fi
done

echo ""
echo "[ RECENT ACCESS LOGS ]"
echo "Last 5 requests:"
sudo tail -5 /var/log/nginx/access.log 2>/dev/null || echo "No access log found"

echo ""
echo "[ RECENT ERROR LOGS ]"
echo "Last 5 errors:"
sudo tail -5 /var/log/nginx/error.log 2>/dev/null || echo "No errors found"

echo ""
echo "============================================"
echo "   NGINX MANAGER COMPLETE"
echo "============================================"
