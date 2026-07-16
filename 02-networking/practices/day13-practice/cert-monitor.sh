#!/bin/bash
# ================================================
# cert-monitor.sh
# Certificate Expiry Monitor
# Author: Asim Raza
# Day 13 of DevOps Journey
# Run daily via cron to alert before expiry
# ================================================

ALERT_DAYS=30
LOG_FILE="/tmp/cert-monitor.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "============================================"
echo "   CERTIFICATE EXPIRY MONITOR"
echo "   Generated: $TIMESTAMP"
echo "   Alert threshold: $ALERT_DAYS days"
echo "============================================"

# Function to check certificate expiry
check_cert_expiry() {
    local name=$1
    local cert_source=$2
    local is_file=$3

    if [ "$is_file" = "true" ]; then
        # Local file
        if [ ! -f "$cert_source" ]; then
            echo "  ❌ $name: File not found: $cert_source"
            return
        fi
        EXPIRY=$(openssl x509 -noout -enddate -in "$cert_source" 2>/dev/null | \
            sed 's/notAfter=//')
    else
        # Remote server
        EXPIRY=$(openssl s_client -connect $cert_source \
            </dev/null 2>/dev/null | \
            openssl x509 -noout -enddate 2>/dev/null | \
            sed 's/notAfter=//')
    fi

    if [ -z "$EXPIRY" ]; then
        echo "  ⚠️  $name: Cannot retrieve certificate"
        return
    fi

    EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s 2>/dev/null)
    NOW_EPOCH=$(date +%s)
    DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))

    if [ $DAYS_LEFT -lt 0 ]; then
        STATUS="❌ EXPIRED"
        echo "  $STATUS: $name expired $((DAYS_LEFT * -1)) days ago"
        echo "$TIMESTAMP - EXPIRED - $name - $((DAYS_LEFT * -1)) days ago" >> $LOG_FILE
    elif [ $DAYS_LEFT -lt 7 ]; then
        STATUS="🚨 CRITICAL"
        echo "  $STATUS: $name expires in $DAYS_LEFT days!"
        echo "$TIMESTAMP - CRITICAL - $name - $DAYS_LEFT days" >> $LOG_FILE
    elif [ $DAYS_LEFT -lt $ALERT_DAYS ]; then
        STATUS="⚠️  WARNING"
        echo "  $STATUS: $name expires in $DAYS_LEFT days"
        echo "$TIMESTAMP - WARNING - $name - $DAYS_LEFT days" >> $LOG_FILE
    else
        STATUS="✅ OK"
        echo "  $STATUS: $name valid for $DAYS_LEFT more days"
    fi
}

echo ""
echo "[ LOCAL CERTIFICATE FILES ]"
# Check local certificate files
if ls /etc/letsencrypt/live/*/fullchain.pem 2>/dev/null; then
    for CERT in /etc/letsencrypt/live/*/fullchain.pem; do
        DOMAIN=$(echo $CERT | cut -d/ -f6)
        check_cert_expiry "$DOMAIN" "$CERT" "true"
    done
else
    echo "  No Let's Encrypt certificates found"
fi

# Check our self-signed cert
SELF_SIGNED="/home/asim_raza/DevOps-journey/02-networking/practices/day13-practice/certs/self-signed.crt"
if [ -f "$SELF_SIGNED" ]; then
    check_cert_expiry "self-signed-localhost" "$SELF_SIGNED" "true"
fi

echo ""
echo "[ REMOTE CERTIFICATE CHECKS ]"
# Check remote websites (if internet available)
for SITE in "google.com:443" "github.com:443"; do
    NAME=$(echo $SITE | cut -d: -f1)
    check_cert_expiry "$NAME" "$SITE" "false"
done

echo ""
echo "[ MONITOR LOG ]"
if [ -f "$LOG_FILE" ]; then
    echo "Recent alerts:"
    tail -5 $LOG_FILE
else
    echo "No alerts logged yet"
fi

echo ""
echo "============================================"
echo "   MONITOR COMPLETE"
echo "============================================"

echo ""
echo "To run daily via cron add:"
echo "0 8 * * * /home/asim_raza/DevOps-journey/02-networking/practices/day13-practice/cert-monitor.sh"
