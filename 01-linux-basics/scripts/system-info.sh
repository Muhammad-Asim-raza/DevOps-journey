#!/bin/bash
# ================================================
# system-info.sh
# DevOps Server Health Check Script
# Author: Muhammad Asim Raza
# Day 1 of DevOps Journey
# ================================================

echo "============================================"
echo "   SERVER HEALTH REPORT"
echo "   Generated: $(date)"
echo "============================================"

echo ""
echo "[ SYSTEM ]"
echo "Hostname    : $(hostname)"
echo "OS          : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
echo "Kernel      : $(uname -r)"
echo "Uptime      : $(uptime -p)"

echo ""
echo "[ HARDWARE ]"
echo "CPU Cores   : $(nproc)"
echo "Total RAM   : $(free -h | awk '/^Mem:/ {print $2}')"
echo "Used RAM    : $(free -h | awk '/^Mem:/ {print $3}')"
echo "Free RAM    : $(free -h | awk '/^Mem:/ {print $4}')"

echo ""
echo "[ DISK USAGE ]"
df -h | grep -v tmpfs | grep -v udev

echo ""
echo "[ TOP 5 CPU PROCESSES ]"
ps aux --sort=-%cpu | awk 'NR<=6 {printf "%-10s %-6s %s\n", $1, $3"%", $11}'

echo ""
echo "[ NETWORK ]"
echo "IP Address  : $(hostname -I | awk '{print $1}')"
echo "Open Ports  : $(ss -tlnp | grep LISTEN | wc -l) listening"

echo ""
echo "============================================"
echo "   REPORT COMPLETE"
echo "============================================"
