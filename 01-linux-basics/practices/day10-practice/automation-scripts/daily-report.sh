#!/bin/bash
REPORT="$HOME/DevOps-journey/01-linux-basics/practices/day10-practice/automation-logs/daily-report.txt"

{
echo "================================"
echo "DAILY SYSTEM REPORT"
echo "Generated: $(date)"
echo "================================"
echo
echo "DISK USAGE:"
df -h
echo
echo "MEMORY USAGE:"
free -h
echo
echo "TOP 10 RUNNING SERVICES:"
systemctl list-units --type=service --state=running | head -10
} > "$REPORT"
