#!/bin/bash
# ================================================
# deploy.sh
# Application Deployment Script
# DevOps Journey - Networking Phase Project
# Author: Asim Raza - Day 18
# Demonstrates: zero-downtime deployment
# ================================================

PROJECT_DIR="$HOME/DevOps-journey/02-networking/project/networking-project"

echo "============================================"
echo "   DEPLOYMENT SCRIPT"
echo "   Zero-Downtime Rolling Deployment"
echo "   Time: $(date)"
echo "============================================"

# ── Function: Check if app is running ──
is_running() {
    local PORT=$1
    nc -zw1 localhost $PORT 2>/dev/null
    return $?
}

# ── Function: Start an app ──
start_app() {
    local APP=$1
    local PORT=$2
    echo "  Starting $APP on port $PORT..."
    python3 "$PROJECT_DIR/apps/$APP/server.py" \
        > "$PROJECT_DIR/logs/$APP.log" 2>&1 &
    echo $! > "/tmp/$APP.pid"
    sleep 2
    if is_running $PORT; then
        echo "  ✅ $APP started (PID: $(cat /tmp/$APP.pid))"
    else
        echo "  ❌ $APP failed to start"
    fi
}

# ── Function: Stop an app gracefully ──
stop_app() {
    local APP=$1
    local PORT=$2
    echo "  Draining $APP (waiting for connections)..."
    sleep 2  # Simulate connection draining
    if [ -f "/tmp/$APP.pid" ]; then
        kill $(cat "/tmp/$APP.pid") 2>/dev/null
        rm -f "/tmp/$APP.pid"
        echo "  ✅ $APP stopped gracefully"
    fi
}

# ── Create log directory ──
mkdir -p "$PROJECT_DIR/logs"

# ── ROLLING DEPLOYMENT ──
echo ""
echo "[ STEP 1: Starting all backend apps ]"
for APP in app1 app2 app3; do
    PORT=$((3000 + ${APP: -1}))
    if is_running $PORT; then
        echo "  ✅ $APP already running on port $PORT"
    else
        start_app $APP $PORT
    fi
done

echo ""
echo "[ STEP 2: Verifying all apps healthy ]"
ALL_HEALTHY=true
for PORT in 3001 3002 3003; do
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        "http://localhost:$PORT/health" 2>/dev/null)
    if [ "$RESPONSE" = "200" ]; then
        echo "  ✅ Port $PORT: HTTP 200 OK"
    else
        echo "  ❌ Port $PORT: HTTP $RESPONSE"
        ALL_HEALTHY=false
    fi
done

echo ""
echo "[ STEP 3: Testing nginx load balancer ]"
NGINX_STATUS=$(curl -k -s -o /dev/null \
    -w "%{http_code}" \
    "https://localhost:8443/nginx-health" 2>/dev/null)
if [ "$NGINX_STATUS" = "200" ]; then
    echo "  ✅ nginx load balancer: HTTP 200 OK"
else
    echo "  ⚠️  nginx load balancer: HTTP $NGINX_STATUS"
    echo "  Run: sudo nginx -t && sudo systemctl reload nginx"
fi

echo ""
echo "[ STEP 4: Running post-deployment checks ]"
echo "  Testing load distribution (3 requests):"
for i in {1..3}; do
    SERVER=$(curl -k -s \
        "https://localhost:8443/" 2>/dev/null | \
        python3 -c "import sys,json; \
        d=json.load(sys.stdin); \
        print(d.get('server','?'))" 2>/dev/null)
    echo "    Request $i → $SERVER"
done

echo ""
if $ALL_HEALTHY; then
    echo "============================================"
    echo "   ✅ DEPLOYMENT SUCCESSFUL"
    echo "   All 3 apps running and healthy"
    echo "   nginx load balancing across them"
    echo "============================================"
else
    echo "============================================"
    echo "   ❌ DEPLOYMENT ISSUES DETECTED"
    echo "   Check logs in: $PROJECT_DIR/logs/"
    echo "============================================"
fi

echo ""
echo "Access your infrastructure:"
echo "  HTTP  (redirects): http://localhost:8080"
echo "  HTTPS (main):      https://localhost:8443"
echo "  Health check:      https://localhost:8443/nginx-health"
echo "  API endpoint:      https://localhost:8443/api"
