#!/bin/bash
# ================================================
# container-lifecycle-demo.sh
# Demonstrates complete container lifecycle
# Author: Asim Raza
# Day 27 of DevOps Journey
# ================================================

CONTAINER="lifecycle-full-demo"

echo "============================================"
echo "   CONTAINER LIFECYCLE DEMONSTRATION"
echo "   Container: $CONTAINER"
echo "============================================"

cleanup() {
    docker rm -f $CONTAINER 2>/dev/null
}
trap cleanup EXIT

echo ""
echo "[ STEP 1: Pull image ]"
docker pull nginx:alpine -q
echo "  ✅ nginx:alpine ready"

echo ""
echo "[ STEP 2: Create container (not started) ]"
docker create \
    --name $CONTAINER \
    --memory 128m \
    --cpus 0.5 \
    -p 8099:80 \
    -e DEMO=lifecycle \
    nginx:alpine
echo "  Status: $(docker inspect \
    --format='{{.State.Status}}' $CONTAINER)"

echo ""
echo "[ STEP 3: Start container ]"
docker start $CONTAINER
sleep 1
echo "  Status: $(docker inspect \
    --format='{{.State.Status}}' $CONTAINER)"
echo "  IP: $(docker inspect \
    --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
    $CONTAINER)"

echo ""
echo "[ STEP 4: Test it is working ]"
HTTP_STATUS=$(curl -o /dev/null -s \
    -w "%{http_code}" \
    --max-time 3 \
    http://localhost:8099 2>/dev/null)
echo "  HTTP Status: $HTTP_STATUS"

echo ""
echo "[ STEP 5: Execute command inside ]"
echo "  nginx version inside container:"
docker exec $CONTAINER nginx -v
echo "  OS inside container:"
docker exec $CONTAINER cat /etc/os-release | \
    grep PRETTY_NAME

echo ""
echo "[ STEP 6: View logs ]"
echo "  Recent logs:"
docker logs --tail 3 $CONTAINER

echo ""
echo "[ STEP 7: Resource stats ]"
docker stats --no-stream $CONTAINER | \
    tail -1 | awk '{printf "  CPU: %s | MEM: %s/%s\n", $3,$4,$6}'

echo ""
echo "[ STEP 8: Pause container ]"
docker pause $CONTAINER
echo "  Status: $(docker inspect \
    --format='{{.State.Status}}' $CONTAINER)"

echo ""
echo "[ STEP 9: Unpause container ]"
docker unpause $CONTAINER
echo "  Status: $(docker inspect \
    --format='{{.State.Status}}' $CONTAINER)"

echo ""
echo "[ STEP 10: Stop container ]"
docker stop $CONTAINER
echo "  Status: $(docker inspect \
    --format='{{.State.Status}}' $CONTAINER)"

echo ""
echo "[ STEP 11: Restart stopped container ]"
docker start $CONTAINER
sleep 1
echo "  Status: $(docker inspect \
    --format='{{.State.Status}}' $CONTAINER)"

echo ""
echo "[ STEP 12: Remove container ]"
docker rm -f $CONTAINER
echo "  Container removed"
echo "  docker ps -a shows:"
docker ps -a | grep $CONTAINER || \
    echo "  (container is gone)"

echo ""
echo "============================================"
echo "   LIFECYCLE DEMO COMPLETE"
echo "============================================"
