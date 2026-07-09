#!/bin/bash
LOG="$HOME/DevOps-journey/01-linux-basics/practices/day10-practice/automation-logs/backup.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
BACKUP_DIR="/tmp/backups"

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/backup-$(date '+%Y%m%d').tar.gz" "$HOME/DevOps-journey" 2>/dev/null

echo "$TIMESTAMP | Backup completed." >> "$LOG"
