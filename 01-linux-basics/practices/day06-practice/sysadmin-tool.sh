#!/bin/bash
# ================================================
# sysadmin-tool.sh
# Complete System Administration Tool
# Author: Asim Raza
# Day 6 of DevOps Journey
# ================================================

echo "============================================"
echo "   SYSTEM ADMINISTRATION REPORT"
echo "   Generated: $(date)"
echo "   Server: $(hostname)"
echo "============================================"

echo ""
echo "[ INSTALLED PACKAGES COUNT ]"
PACKAGE_COUNT=$(dpkg -l | wc -l)
echo "Total packages installed: $PACKAGE_COUNT"

echo ""
echo "[ CHECKING IMPORTANT PACKAGES ]"
PACKAGES="nginx curl wget git"
for PACKAGE in $PACKAGES
do
    if dpkg -l | grep -q "^ii  $PACKAGE"; then
        echo "✅ $PACKAGE = installed"
    else
        echo "❌ $PACKAGE = NOT installed"
    fi
done

echo ""
echo "[ ENVIRONMENT VARIABLES ]"
echo "User     : $USER"
echo "Home     : $HOME"
echo "Shell    : $SHELL"
echo "Path     : $PATH"

echo ""
echo "[ DISK USAGE ]"
df -h | grep -v tmpfs | grep -v udev

echo ""
echo "[ LARGEST FOLDERS IN HOME ]"
du -sh ~/* 2>/dev/null | sort -rh | head -5

echo ""
echo "[ NETWORK INFORMATION ]"
echo "IP Address: $(hostname -I)"
echo "Listening ports:"
ss -tlnp | grep LISTEN

echo ""
echo "[ RECENT SYSTEM ERRORS ]"
echo "Last 5 system errors:"
journalctl -p err --since "1 hour ago" --no-pager | tail -5

echo ""
echo "[ SERVICE STATUS ]"
SERVICES="nginx ssh cron"
for SERVICE in $SERVICES
do
    if systemctl is-active --quiet $SERVICE; then
        echo "✅ $SERVICE = running"
    else
        echo "❌ $SERVICE = not running"
    fi
done

echo ""
echo "============================================"
echo "   REPORT COMPLETE"
echo "============================================"
