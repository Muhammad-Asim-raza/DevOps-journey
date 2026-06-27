#!/bin/bash
# ================================================
# process-monitor.sh
# DevOps Process Monitor Script
# Author: Asim Raza
# Day 3 of DevOps Journey
# ================================================

echo "============================================"
echo "   PROCESS MONITOR REPORT"
echo "   Generated: $(date)"
echo "============================================"

echo ""
echo "[ TOTAL PROCESSES RUNNING ]"
ps aux | wc -l

echo ""
echo "[ TOP 5 CPU CONSUMING PROCESSES ]"
ps aux --sort=-%cpu | head -6

echo ""
echo "[ TOP 5 MEMORY CONSUMING PROCESSES ]"
ps aux --sort=-%mem | head -6

echo ""
echo "[ CHECKING IMPORTANT SERVICES ]"

# Check SSH service
if systemctl is-active --quiet ssh; then
    echo "✅ SSH Service     = RUNNING"
else
    echo "❌ SSH Service     = NOT RUNNING"
fi

# Check cron service
if systemctl is-active --quiet cron; then
    echo "✅ Cron Service    = RUNNING"
else
    echo "❌ Cron Service    = NOT RUNNING"
fi

echo ""
echo "[ SYSTEM LOAD ]"
uptime

echo ""
echo "[ MEMORY USAGE ]"
free -h

echo ""
echo "============================================"
echo "   MONITOR REPORT COMPLETE"
echo "============================================"
