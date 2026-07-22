#!/bin/bash
# ================================================
# lb-simulator.sh
# Load Balancer Algorithm Simulator
# Shows how different algorithms distribute traffic
# Author: Asim Raza
# Day 16 of DevOps Journey
# ================================================

echo "============================================"
echo "   LOAD BALANCER ALGORITHM SIMULATOR"
echo "   Author: Asim Raza - Day 16"
echo "============================================"

# Define servers
SERVERS=("web1:3000" "web2:3001" "web3:3002")
WEIGHTS=(3 2 1)
CONNECTIONS=(0 0 0)
REQUESTS=12

# Round Robin
echo ""
echo "[ ALGORITHM 1: ROUND ROBIN ]"
echo "Requests distributed equally to each server"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
declare -A RR_COUNT
for SERVER in "${SERVERS[@]}"; do
    RR_COUNT[$SERVER]=0
done

SERVER_COUNT=${#SERVERS[@]}
for i in $(seq 1 $REQUESTS); do
    IDX=$(( (i-1) % SERVER_COUNT ))
    SERVER=${SERVERS[$IDX]}
    RR_COUNT[$SERVER]=$((${RR_COUNT[$SERVER]} + 1))
    echo "  Request $i → $SERVER"
done

echo ""
echo "Distribution:"
for SERVER in "${SERVERS[@]}"; do
    echo "  $SERVER: ${RR_COUNT[$SERVER]} requests"
done

# Weighted Round Robin
echo ""
echo "[ ALGORITHM 2: WEIGHTED ROUND ROBIN ]"
echo "web1 weight=3, web2 weight=2, web3 weight=1"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
TOTAL_WEIGHT=6
declare -A WRR_COUNT
for SERVER in "${SERVERS[@]}"; do
    WRR_COUNT[$SERVER]=0
done

for i in $(seq 1 $REQUESTS); do
    RAND=$((RANDOM % TOTAL_WEIGHT))
    if [ $RAND -lt 3 ]; then
        SERVER=${SERVERS[0]}
    elif [ $RAND -lt 5 ]; then
        SERVER=${SERVERS[1]}
    else
        SERVER=${SERVERS[2]}
    fi
    WRR_COUNT[$SERVER]=$((${WRR_COUNT[$SERVER]} + 1))
    echo "  Request $i → $SERVER"
done

echo ""
echo "Distribution (expected: web1=6, web2=4, web3=2):"
for SERVER in "${SERVERS[@]}"; do
    echo "  $SERVER: ${WRR_COUNT[$SERVER]} requests"
done

# Least Connections
echo ""
echo "[ ALGORITHM 3: LEAST CONNECTIONS ]"
echo "Send to server with fewest active connections"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
CONN=(2 5 1)  # Simulate current connections
for i in $(seq 1 $REQUESTS); do
    # Find server with minimum connections
    MIN=${CONN[0]}
    MIN_IDX=0
    for j in 1 2; do
        if [ ${CONN[$j]} -lt $MIN ]; then
            MIN=${CONN[$j]}
            MIN_IDX=$j
        fi
    done
    SERVER=${SERVERS[$MIN_IDX]}
    echo "  Request $i → $SERVER (had ${CONN[$MIN_IDX]} connections)"
    CONN[$MIN_IDX]=$((${CONN[$MIN_IDX]} + 1))
    # Simulate some connections finishing
    if [ $((i % 3)) -eq 0 ]; then
        RANDOM_SERVER=$((RANDOM % 3))
        if [ ${CONN[$RANDOM_SERVER]} -gt 0 ]; then
            CONN[$RANDOM_SERVER]=$((${CONN[$RANDOM_SERVER]} - 1))
        fi
    fi
done

# IP Hash
echo ""
echo "[ ALGORITHM 4: IP HASH (Sticky Sessions) ]"
echo "Same client IP always goes to same server"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
CLIENT_IPS=("192.168.1.10" "192.168.1.10" "192.168.1.20" \
            "192.168.1.10" "192.168.1.30" "192.168.1.20")

for IP in "${CLIENT_IPS[@]}"; do
    # Simple hash: sum of octets mod server count
    HASH=0
    for OCTET in $(echo $IP | tr '.' ' '); do
        HASH=$((HASH + OCTET))
    done
    IDX=$((HASH % ${#SERVERS[@]}))
    echo "  Client $IP → ${SERVERS[$IDX]}"
done

echo ""
echo "============================================"
echo "   ALGORITHM COMPARISON SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Round Robin    : Equal distribution, simple"
echo "Weighted RR    : For unequal server capacity"
echo "Least Conn     : Best for varied request time"
echo "IP Hash        : Sticky sessions, same server"
echo "Random         : Simple random selection"
echo "First          : Fill server before next one"
echo "============================================"
