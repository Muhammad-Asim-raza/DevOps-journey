#!/bin/bash
# ================================================
# cron-manager.sh
# Cron Job Reference and Management
# Author: Asim Raza
# Day 10 of DevOps Journey
# ================================================

echo "============================================"
echo "   CRON JOB MANAGER"
echo "   Generated: $(date)"
echo "============================================"

echo ""
echo "[ CRON SERVICE STATUS ]"
sudo systemctl status cron | grep -E "Active:|Loaded:"

echo ""
echo "[ YOUR CURRENT CRON JOBS ]"
if crontab -l 2>/dev/null; then
    echo "Above are your scheduled jobs"
else
    echo "No cron jobs currently scheduled"
fi

echo ""
echo "[ SYSTEM CRON JOBS ]"
echo "System-wide cron jobs:"
ls /etc/cron.d/ 2>/dev/null
ls /etc/cron.daily/ 2>/dev/null
ls /etc/cron.weekly/ 2>/dev/null
ls /etc/cron.monthly/ 2>/dev/null

echo ""
echo "[ RECENT CRON ACTIVITY ]"
grep CRON /var/log/syslog 2>/dev/null | tail -10 || \
grep CRON /var/log/auth.log 2>/dev/null | tail -10 || \
echo "No recent cron activity found"

echo ""
echo "[ CRON SYNTAX REFERENCE ]"
echo "  * * * * * command"
echo "  │ │ │ │ │"
echo "  │ │ │ │ └── Weekday (0-7, 0=Sun)"
echo "  │ │ │ └──── Month (1-12)"
echo "  │ │ └────── Day (1-31)"
echo "  │ └──────── Hour (0-23)"
echo "  └────────── Minute (0-59)"
echo ""
echo "  */15 * * * *  = every 15 minutes"
echo "  0 9 * * 1     = every Monday 9am"
echo "  0 0 * * *     = every day midnight"
echo "  0 0 1 * *     = first of every month"
echo "  @reboot       = on system start"
echo "  @daily        = every day"
echo "  @weekly       = every week"

echo ""
echo "============================================"
echo "   CRON MANAGER COMPLETE"
echo "============================================"
