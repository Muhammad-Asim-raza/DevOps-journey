#!/bin/bash
# ================================================
# ssl-checker.sh
# SSL/TLS Certificate Checker
# Author: Asim Raza
# Day 13 of DevOps Journey
# Usage: bash ssl-checker.sh [hostname] [port]
# ================================================

HOST=${1:-"localhost"}
PORT=${2:-"8443"}
CERT_FILE=${3:-""}

echo "============================================"
echo "   SSL/TLS CERTIFICATE CHECKER"
echo "   Target: $HOST:$PORT"
echo "   Generated: $(date)"
echo "============================================"

# Function to check remote certificate
check_remote_cert() {
    echo ""
    echo "[ CONNECTING TO $HOST:$PORT ]"

    CERT_INFO=$(openssl s_client -connect $HOST:$PORT \
        -servername $HOST </dev/null 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo "❌ Cannot connect to $HOST:$PORT"
        return 1
    fi

    echo "✅ Connection successful"

    echo ""
    echo "[ CERTIFICATE DETAILS ]"
    echo "$CERT_INFO" | openssl x509 -text -noout 2>/dev/null | \
        grep -E "Subject:|Issuer:|Not Before:|Not After:|DNS:"

    echo ""
    echo "[ PROTOCOL AND CIPHER ]"
    echo "$CERT_INFO" | grep -E "Protocol|Cipher is"

    echo ""
    echo "[ CERTIFICATE EXPIRY ]"
    EXPIRY=$(echo "$CERT_INFO" | openssl x509 -noout -enddate 2>/dev/null | \
        sed 's/notAfter=//')
    echo "Expires: $EXPIRY"

    # Calculate days until expiry
    EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s 2>/dev/null)
    NOW_EPOCH=$(date +%s)
    DAYS_LEFT=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))

    if [ $DAYS_LEFT -lt 0 ]; then
        echo "❌ CERTIFICATE EXPIRED $((DAYS_LEFT * -1)) days ago!"
    elif [ $DAYS_LEFT -lt 7 ]; then
        echo "⚠️  CRITICAL: Only $DAYS_LEFT days until expiry!"
    elif [ $DAYS_LEFT -lt 30 ]; then
        echo "⚠️  WARNING: $DAYS_LEFT days until expiry - renew soon"
    else
        echo "✅ Certificate valid for $DAYS_LEFT more days"
    fi
}

# Function to check local certificate file
check_local_cert() {
    local cert_file=$1
    echo ""
    echo "[ LOCAL CERTIFICATE: $cert_file ]"

    if [ ! -f "$cert_file" ]; then
        echo "❌ Certificate file not found: $cert_file"
        return 1
    fi

    echo "✅ Certificate file exists"

    echo ""
    echo "[ CERTIFICATE INFORMATION ]"
    openssl x509 -in $cert_file -text -noout | \
        grep -E "Subject:|Issuer:|Not Before:|Not After:"

    echo ""
    echo "[ CERTIFICATE VALIDITY ]"
    openssl x509 -in $cert_file -noout -checkend 0 && \
        echo "✅ Certificate is currently valid" || \
        echo "❌ Certificate has EXPIRED"

    # Check if expires in 30 days
    openssl x509 -in $cert_file -noout -checkend 2592000 && \
        echo "✅ Certificate valid for more than 30 days" || \
        echo "⚠️  Certificate expires within 30 days"
}

# Run checks
check_remote_cert

if [ -n "$CERT_FILE" ]; then
    check_local_cert $CERT_FILE
fi

echo ""
echo "[ SSL SECURITY HEADERS CHECK ]"
HEADERS=$(curl -sk -I https://$HOST:$PORT 2>/dev/null)

for HEADER in "Strict-Transport-Security" "X-Frame-Options" \
              "X-Content-Type-Options" "X-XSS-Protection"; do
    if echo "$HEADERS" | grep -qi "$HEADER"; then
        echo "✅ $HEADER header present"
    else
        echo "❌ $HEADER header MISSING"
    fi
done

echo ""
echo "============================================"
echo "   SSL CHECK COMPLETE"
echo "============================================"
