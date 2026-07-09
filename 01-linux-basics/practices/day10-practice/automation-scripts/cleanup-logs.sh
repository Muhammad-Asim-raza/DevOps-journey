#!/bin/bash
LOG="$HOME/DevOps-journey/01-linux-basics/practices/day10-practice/automation-logs/cleanup.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

DELETED=$(find /tmp -name "*.log" -mtime +7 -delete -print 2>/dev/null | wc -l)

echo "$TIMESTAMP | Deleted $DELETED old log files." >> "$LOG"
