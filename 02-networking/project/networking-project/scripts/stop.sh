#!/bin/bash
# ================================================
# stop.sh
# Stop all project services
# DevOps Journey - Networking Phase Project
# ================================================

echo "Stopping all backend applications..."

for APP in app1 app2 app3; do
    if [ -f "/tmp/$APP.pid" ]; then
        PID=$(cat "/tmp/$APP.pid")
        kill $PID 2>/dev/null
        rm -f "/tmp/$APP.pid"
        echo "✅ $APP stopped (PID: $PID)"
    else
        # Try to find by port
        PORT=$((3000 + ${APP: -1}))
        PID=$(lsof -ti :$PORT 2>/dev/null)
        if [ -n "$PID" ]; then
            kill $PID 2>/dev/null
            echo "✅ $APP stopped (found on port $PORT)"
        else
            echo "⚠️  $APP was not running"
        fi
    fi
done

echo ""
echo "All applications stopped."
