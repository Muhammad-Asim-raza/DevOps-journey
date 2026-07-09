#!/bin/bash
# ================================================
# monitor.sh
# Continuous Server Monitor
# Runs as a systemd service
# ================================================

LOG_FILE="/home/asim_raza/DevOps-journey/01-linux-basics/practices/day10-practice/myservice/monitor.log"

echo "Monitor service started at $(date)" >> $LOG_FILE

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)
    RAM=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100}')
    DISK=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

    echo "$TIMESTAMP CPU:${CPU}% RAM:${RAM}% DISK:${DISK}%" >> $LOG_FILE

    if [ "$DISK" -gt 80 ]; then
        echo "$TIMESTAMP WARNING: Disk usage critical at ${DISK}%" >> $LOG_FILE
    fi

    sleep 60
done
