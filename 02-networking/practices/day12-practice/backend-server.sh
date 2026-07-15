#!/bin/bash
# Simple backend server for testing
# Runs Python's built-in HTTP server
# on a specific port

PORT=${1:-3000}
CONTENT_DIR="/tmp/backend-$PORT"

mkdir -p $CONTENT_DIR

cat > $CONTENT_DIR/index.html << EOF
<!DOCTYPE html>
<html>
<body>
    <h1>Backend Server Response</h1>
    <p>Port: $PORT</p>
    <p>Server: Python HTTP Server</p>
    <p>Time: $(date)</p>
    <p>This is a mock backend application</p>
</body>
</html>
EOF

echo "Starting backend server on port $PORT"
echo "Serving from: $CONTENT_DIR"
cd $CONTENT_DIR
python3 -m http.server $PORT &
echo "Backend PID: $!"
echo $! > /tmp/backend-$PORT.pid
