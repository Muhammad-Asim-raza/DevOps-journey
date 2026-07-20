#!/bin/bash
# ================================================
# port-scanner.sh
# Simple Port Scanner for Network Auditing
# Author: Asim Raza
# Day 14 of DevOps Journey
# Usage: bash port-scanner.sh [host] [port-range]
# ================================================

HOST=${1:-"localhost"}
START_PORT=${2:-"1"}
END_PORT=${3:-"1024"}

echo "============================================"
echo "   PORT SCANNER"
echo "   Target: $HOST"
echo "   Range : $START_PORT - $END_PORT"
echo "   Generated: $(date)"
echo "============================================"

OPEN_PORTS=()
CLOSED_COUNT=0

echo ""
echo "Scanning..."
echo ""

# Well-known ports to scan
IMPORTANT_PORTS=(21 22 23 25 53 80 443 3000 3306 5432 6379 8080 8443 27017)

echo "[ CHECKING IMPORTANT PORTS ]"
for PORT in "${IMPORTANT_PORTS[@]}"; do
    if nc -zw1 $HOST $PORT 2>/dev/null; then
        SERVICE=""
        case $PORT in
            21)  SERVICE="FTP" ;;
            22)  SERVICE="SSH" ;;
            23)  SERVICE="Telnet (INSECURE!)" ;;
            25)  SERVICE="SMTP" ;;
            53)  SERVICE="DNS" ;;
            80)  SERVICE="HTTP" ;;
            443) SERVICE="HTTPS" ;;
            3000) SERVICE="Node.js/Dev" ;;
            3306) SERVICE="MySQL" ;;
            5432) SERVICE="PostgreSQL" ;;
            6379) SERVICE="Redis" ;;
            8080) SERVICE="HTTP-alt/Jenkins" ;;
            8443) SERVICE="HTTPS-alt" ;;
            27017) SERVICE="MongoDB" ;;
        esac
        echo "  ✅ Port $PORT OPEN - $SERVICE"
        OPEN_PORTS+=($PORT)

        # Security warnings
        if [ $PORT -eq 23 ]; then
            echo "     ⚠️  WARNING: Telnet is insecure! Disable it!"
        fi
        if [ $PORT -eq 3306 ] && [ "$HOST" != "localhost" ] && \
           [ "$HOST" != "127.0.0.1" ]; then
            echo "     ⚠️  WARNING: MySQL exposed externally!"
        fi
        if [ $PORT -eq 5432 ] && [ "$HOST" != "localhost" ] && \
           [ "$HOST" != "127.0.0.1" ]; then
            echo "     ⚠️  WARNING: PostgreSQL exposed externally!"
        fi
        if [ $PORT -eq 6379 ] && [ "$HOST" != "localhost" ] && \
           [ "$HOST" != "127.0.0.1" ]; then
            echo "     ⚠️  WARNING: Redis exposed externally!"
        fi
    fi
done

echo ""
echo "[ SUMMARY ]"
echo "  Open ports found: ${#OPEN_PORTS[@]}"
echo "  Open ports: ${OPEN_PORTS[*]}"

if [ ${#OPEN_PORTS[@]} -eq 0 ]; then
    echo "  No open ports found (or host unreachable)"
fi

echo ""
echo "[ SECURITY ASSESSMENT ]"
# Check for dangerous open ports on remote hosts
if [ "$HOST" != "localhost" ] && [ "$HOST" != "127.0.0.1" ]; then
    RISKY=0
    for PORT in "${OPEN_PORTS[@]}"; do
        if [ $PORT -eq 3306 ] || [ $PORT -eq 5432 ] || \
           [ $PORT -eq 6379 ] || [ $PORT -eq 27017 ] || \
           [ $PORT -eq 23 ]; then
            RISKY=$((RISKY + 1))
        fi
    done

    if [ $RISKY -gt 0 ]; then
        echo "  ❌ SECURITY RISK: $RISKY sensitive services exposed!"
        echo "     Databases should NEVER be accessible externally"
        echo "     Use firewall rules and VPN for database access"
    else
        echo "  ✅ No obviously risky ports exposed externally"
    fi
fi

echo ""
echo "============================================"
echo "   SCAN COMPLETE"
echo "============================================"
