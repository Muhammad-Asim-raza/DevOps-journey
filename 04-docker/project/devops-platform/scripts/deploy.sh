#!/bin/bash
# ================================================
# deploy.sh - Deploy DevOps Platform
# Author: Asim Raza - Day 38
# ================================================
set -e

echo "╔══════════════════════════════════════╗"
echo "║    DEVOPS PLATFORM DEPLOYMENT        ║"
echo "╚══════════════════════════════════════╝"

# Check .env exists
if [ ! -f .env ]; then
    echo "❌ .env file missing!"
    echo "   Copy .env.example → .env and fill values"
    exit 1
fi

# Build and deploy
echo ""
echo "[ 1/4 ] Building images..."
docker compose build --no-cache

echo ""
echo "[ 2/4 ] Pulling base images..."
docker compose pull --ignore-buildable

echo ""
echo "[ 3/4 ] Starting stack..."
docker compose up -d

echo ""
echo "[ 4/4 ] Waiting for health checks..."
TIMEOUT=90
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
    UNHEALTHY=$(docker compose ps \
        --format json 2>/dev/null | \
        python3 -c "
import json,sys
healthy=0; unhealthy=0
for line in sys.stdin:
    line=line.strip()
    if not line: continue
    try:
        s=json.loads(line)
        h=s.get('Health','')
        if h=='healthy': healthy+=1
        elif h in ['unhealthy','starting']: unhealthy+=1
    except: pass
print(f'{unhealthy}')
" 2>/dev/null || echo "0")

    if [ "$UNHEALTHY" = "0" ]; then
        echo "✅ All services healthy!"
        break
    fi
    echo "  Waiting... ($ELAPSED/${TIMEOUT}s)"
    sleep 5
    ELAPSED=$((ELAPSED + 5))
done

echo ""
echo "╔══════════════════════════════════════╗"
echo "║    DEPLOYMENT COMPLETE               ║"
echo "╠══════════════════════════════════════╣"
echo "║  App:        http://localhost:8600   ║"
echo "║  Prometheus: http://localhost:8601   ║"
echo "║  Grafana:    http://localhost:8602   ║"
echo "╚══════════════════════════════════════╝"

echo ""
docker compose ps
