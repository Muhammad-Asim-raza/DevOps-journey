#!/bin/bash
LOG="$HOME/DevOps-journey/01-linux-basics/practices/day10-practice/automation-logs/health.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)
RAM=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100}')
DISK=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

echo "$TIMESTAMP | CPU:${CPU}% | RAM:${RAM}% | DISK:${DISK}%" >> "$LOG"

if [ "$DISK" -gt 80 ]; then
    echo "$TIMESTAMP | ALERT: Disk at ${DISK}%" >> "$LOG"
fi

if [ "$RAM" -gt 90 ]; then
    echo "$TIMESTAMP | ALERT: RAM at ${RAM}%" >> "$LOG"
fi
