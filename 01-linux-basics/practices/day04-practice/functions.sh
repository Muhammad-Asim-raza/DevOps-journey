#!/bin/bash
# ================================================
# functions.sh — Reusable Code Blocks
# ================================================

# Define a function
check_service() {
    SERVICE=$1
    # $1 = first argument passed to function

    if systemctl is-active --quiet $SERVICE; then
        echo "✅ $SERVICE = RUNNING"
    else
        echo "❌ $SERVICE = NOT RUNNING"
    fi
}

# Define another function
print_header() {
    echo "=========================="
    echo "  $1"
    echo "=========================="
}

# Define disk check function
check_disk() {
    USAGE=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')
    if [ $USAGE -gt 80 ]; then
        echo "⚠️  Disk WARNING: ${USAGE}% used"
    else
        echo "✅ Disk OK: ${USAGE}% used"
    fi
}

# ── NOW USE THE FUNCTIONS ──

print_header "SERVICE STATUS REPORT"

echo ""
echo "[ CHECKING SERVICES ]"
check_service ssh
check_service cron

echo ""
print_header "DISK STATUS REPORT"
check_disk

echo ""
print_header "REPORT COMPLETE"
echo "Generated: $(date)"
