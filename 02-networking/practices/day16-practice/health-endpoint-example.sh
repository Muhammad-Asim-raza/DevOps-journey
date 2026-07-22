#!/bin/bash
# ================================================
# health-endpoint-example.sh
# Shows what a proper /health endpoint returns
# Author: Asim Raza
# Day 16 of DevOps Journey
# ================================================

# Start a simple HTTP server that responds to health checks
# This simulates what your application should expose

PORT=${1:-3000}
RESPONSE_FILE="/tmp/health-response-$PORT.html"

cat > $RESPONSE_FILE << EOF
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 89

{
  "status": "healthy",
  "port": $PORT,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "checks": {
    "database": "ok",
    "cache": "ok"
  }
}
EOF

echo "Health check endpoint example for port $PORT:"
echo ""
echo "A proper /health endpoint should:"
echo "✅ Return HTTP 200 when healthy"
echo "✅ Return HTTP 503 when unhealthy"
echo "✅ Check dependencies (DB, cache, etc)"
echo "✅ Respond within 1-2 seconds"
echo "✅ Not require authentication"
echo "✅ Return JSON with status details"
echo ""
echo "Example response:"
cat $RESPONSE_FILE

echo ""
echo "HAProxy health check config:"
echo "  option httpchk GET /health"
echo "  http-check expect status 200"
echo ""
echo "nginx health check in upstream:"
echo "  server app1 127.0.0.1:3000;"
echo "  # HAProxy checks /health endpoint"
echo "  # nginx uses passive health checks"
