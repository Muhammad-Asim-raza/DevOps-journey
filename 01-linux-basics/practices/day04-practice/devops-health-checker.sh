#!/bin/bash
# ================================================
# devops-health-checker.sh
# Complete Server Health Check Script
# Author: Asim Raza
# Day 4 of DevOps Journey
# ================================================

# ── VARIABLES ──
REPORT_FILE="/home/asim_raza/health-report.txt"
DATE=$(date)
HOSTNAME=$(hostname)
DISK_THRESHOLD=80
RAM_THRESHOLD=90

# ── FUNCTIONS ──
print_header() {
    echo "============================================"
    echo "  $1"
    echo "============================================"
}

check_service() {
    if systemctl is-active --quiet $1; then
        echo "✅ $1 = RUNNING"
    else
        echo "❌ $1 = NOT RUNNING"
    fi
}

check_disk() {
    USAGE=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')
    if [ $USAGE -gt $DISK_THRESHOLD ]; then
        echo "⚠️  WARNING: Disk at ${USAGE}%"
    else
        echo "✅ Disk OK: ${USAGE}% used"
    fi
}

check_ram() {
    TOTAL=$(free | awk '/^Mem:/ {print $2}')
    USED=$(free | awk '/^Mem:/ {print $3}')
    PERCENT=$((USED * 100 / TOTAL))
    if [ $PERCENT -gt $RAM_THRESHOLD ]; then
        echo "⚠️  WARNING: RAM at ${PERCENT}%"
    else
        echo "✅ RAM OK: ${PERCENT}% used"
    fi
}

# ── MAIN SCRIPT ──
print_header "DEVOPS HEALTH REPORT"
echo "Date     : $DATE"
echo "Server   : $HOSTNAME"
echo "Run by   : $USER"

echo ""
print_header "SERVICE STATUS"
SERVICES="ssh cron"
for SERVICE in $SERVICES
do
    check_service $SERVICE
done

echo ""
print_header "RESOURCE STATUS"
check_disk
check_ram

echo ""
print_header "TOP 3 PROCESSES BY CPU"
ps aux --sort=-%cpu | awk 'NR>1 && NR<=4 {print $1, $3"%", $11}'

echo ""
print_header "SYSTEM UPTIME"
uptime

echo ""
print_header "REPORT COMPLETE"
