#!/bin/bash
# ================================================
# log-analyzer.sh
# Professional Log Analysis Tool
# Author: Asim Raza
# Day 7 of DevOps Journey
# Usage: bash log-analyzer.sh <logfile>
# ================================================

# Check if log file was provided
if [ -z "$1" ]; then
    echo "Usage: bash log-analyzer.sh <logfile>"
    echo "Example: bash log-analyzer.sh app.log"
    exit 1
fi

# Store filename in variable
LOG_FILE="$1"

# Check if file actually exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' not found"
    exit 1
fi

echo "============================================"
echo "   PROFESSIONAL LOG ANALYZER"
echo "   File     : $LOG_FILE"
echo "   Generated: $(date)"
echo "   Lines    : $(wc -l < $LOG_FILE)"
echo "============================================"

echo ""
echo "[ LOG LEVEL BREAKDOWN ]"
awk '{print $3}' $LOG_FILE \
| sort | uniq -c | sort -rn \
| awk '{printf "  %-12s : %s entries\n", $2, $1}'

echo ""
echo "[ ALL ERROR LINES ]"
grep "ERROR" $LOG_FILE | while read line; do
    echo "  ❌ $line"
done

echo ""
echo "[ CRITICAL EVENTS ]"
CRITICAL_COUNT=$(grep -c "CRITICAL" $LOG_FILE)
if [ $CRITICAL_COUNT -gt 0 ]; then
    echo "  ⚠️  $CRITICAL_COUNT CRITICAL events found!"
    grep -B 2 "CRITICAL" $LOG_FILE | while read line; do
        echo "  >>> $line"
    done
else
    echo "  ✅ No critical events"
fi

echo ""
echo "[ MOST AFFECTED COMPONENTS ]"
grep -E "ERROR|CRITICAL" $LOG_FILE \
| awk '{print $4}' \
| sort | uniq -c | sort -rn \
| awk '{printf "  %-15s : %s errors\n", $2, $1}'

echo ""
echo "[ SUSPICIOUS IP ADDRESSES ]"
FAILED=$(grep -c "Failed login" $LOG_FILE 2>/dev/null || echo 0)
if [ "$FAILED" -gt 0 ]; then
    echo "  ⚠️  Failed logins: $FAILED attempts"
    grep "Failed login" $LOG_FILE \
    | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' \
    | sort | uniq -c | sort -rn \
    | awk '{printf "  IP: %-16s Attempts: %s\n", $2, $1}'
else
    echo "  ✅ No suspicious activity"
fi

echo ""
echo "[ WARNING SUMMARY ]"
grep "WARNING" $LOG_FILE | while read line; do
    echo "  ⚠️  $line"
done

echo ""
echo "============================================"
echo "   ANALYSIS COMPLETE"
echo "============================================"
