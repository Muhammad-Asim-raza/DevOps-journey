#!/bin/bash
# ================================================
# automation-suite.sh
# Complete Linux Automation Suite
# Author: M Asim Raza
# Day 10 of DevOps Journey
# ================================================

BASE_DIR="$HOME/DevOps-journey/01-linux-basics/practices/day10-practice"
SCRIPTS_DIR="$BASE_DIR/automation-scripts"
LOGS_DIR="$BASE_DIR/automation-logs"

echo "============================================"
echo "   LINUX AUTOMATION SUITE"
echo "   Generated: $(date)"
echo "============================================"

echo ""
echo "[ STEP 1: Creating directories ]"
mkdir -p "$SCRIPTS_DIR" "$LOGS_DIR"
echo "✅ Created: $SCRIPTS_DIR"
echo "✅ Created: $LOGS_DIR"

echo ""
echo "[ STEP 2: Creating automation scripts ]"

# Health Check Script
cat > "$SCRIPTS_DIR/health-check.sh" <<SCRIPT
#!/bin/bash
LOG="\$HOME/DevOps-journey/01-linux-basics/practices/day10-practice/automation-logs/health.log"
TIMESTAMP=\$(date '+%Y-%m-%d %H:%M:%S')
CPU=\$(top -bn1 | grep "Cpu(s)" | awk '{print \$2}' | cut -d. -f1)
RAM=\$(free | awk '/^Mem:/ {printf "%.0f", \$3/\$2 * 100}')
DISK=\$(df / | tail -1 | awk '{print \$5}' | tr -d '%')

echo "\$TIMESTAMP | CPU:\${CPU}% | RAM:\${RAM}% | DISK:\${DISK}%" >> "\$LOG"

if [ "\$DISK" -gt 80 ]; then
    echo "\$TIMESTAMP | ALERT: Disk at \${DISK}%" >> "\$LOG"
fi

if [ "\$RAM" -gt 90 ]; then
    echo "\$TIMESTAMP | ALERT: RAM at \${RAM}%" >> "\$LOG"
fi
SCRIPT

chmod +x "$SCRIPTS_DIR/health-check.sh"
echo "✅ Created: health-check.sh"

# Backup Script
cat > "$SCRIPTS_DIR/backup.sh" <<SCRIPT
#!/bin/bash
LOG="\$HOME/DevOps-journey/01-linux-basics/practices/day10-practice/automation-logs/backup.log"
TIMESTAMP=\$(date '+%Y-%m-%d %H:%M:%S')
BACKUP_DIR="/tmp/backups"

mkdir -p "\$BACKUP_DIR"

tar -czf "\$BACKUP_DIR/backup-\$(date '+%Y%m%d').tar.gz" \
"\$HOME/DevOps-journey" 2>/dev/null

echo "\$TIMESTAMP | Backup completed." >> "\$LOG"
SCRIPT

chmod +x "$SCRIPTS_DIR/backup.sh"
echo "✅ Created: backup.sh"

# Cleanup Script
cat > "$SCRIPTS_DIR/cleanup-logs.sh" <<SCRIPT
#!/bin/bash
LOG="\$HOME/DevOps-journey/01-linux-basics/practices/day10-practice/automation-logs/cleanup.log"
TIMESTAMP=\$(date '+%Y-%m-%d %H:%M:%S')

DELETED=\$(find /tmp -name "*.log" -mtime +7 -delete -print 2>/dev/null | wc -l)

echo "\$TIMESTAMP | Deleted \$DELETED old log files." >> "\$LOG"
SCRIPT

chmod +x "$SCRIPTS_DIR/cleanup-logs.sh"
echo "✅ Created: cleanup-logs.sh"

# Daily Report Script
cat > "$SCRIPTS_DIR/daily-report.sh" <<SCRIPT
#!/bin/bash
REPORT="\$HOME/DevOps-journey/01-linux-basics/practices/day10-practice/automation-logs/daily-report.txt"

{
echo "================================"
echo "DAILY SYSTEM REPORT"
echo "Generated: \$(date)"
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
} > "\$REPORT"
SCRIPT

chmod +x "$SCRIPTS_DIR/daily-report.sh"
echo "✅ Created: daily-report.sh"

echo ""
echo "[ STEP 3: Running all scripts once ]"

bash "$SCRIPTS_DIR/health-check.sh" && echo "✅ health-check.sh OK"
bash "$SCRIPTS_DIR/backup.sh" && echo "✅ backup.sh OK"
bash "$SCRIPTS_DIR/cleanup-logs.sh" && echo "✅ cleanup-logs.sh OK"
bash "$SCRIPTS_DIR/daily-report.sh" && echo "✅ daily-report.sh OK"

echo ""
echo "[ STEP 4: Example Crontab ]"
echo ""
echo "SHELL=/bin/bash"
echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
echo ""
echo "*/5 * * * * $SCRIPTS_DIR/health-check.sh"
echo "0 0 * * * $SCRIPTS_DIR/backup.sh"
echo "0 2 * * 0 $SCRIPTS_DIR/cleanup-logs.sh"
echo "0 8 * * * $SCRIPTS_DIR/daily-report.sh"

echo ""
echo "[ STEP 5: Showing logs ]"
echo ""

echo "Health Log:"
cat "$LOGS_DIR/health.log" 2>/dev/null || echo "No health log yet."

echo ""
echo "Backup Log:"
cat "$LOGS_DIR/backup.log" 2>/dev/null || echo "No backup log yet."

echo ""
echo "Cleanup Log:"
cat "$LOGS_DIR/cleanup.log" 2>/dev/null || echo "No cleanup log yet."

echo ""
echo "Daily Report:"
head -20 "$LOGS_DIR/daily-report.txt" 2>/dev/null || echo "No report yet."

echo ""
echo "============================================"
echo " AUTOMATION SUITE COMPLETE "
echo " Scripts : $SCRIPTS_DIR"
echo " Logs    : $LOGS_DIR"
echo "============================================"
