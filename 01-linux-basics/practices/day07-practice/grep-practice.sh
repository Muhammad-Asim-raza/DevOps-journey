#!/bin/bash
# ================================================
# grep-practice.sh
# grep Text Search Demonstrations
# Author: Asim Raza
# Day 7 of DevOps Journey
# ================================================

echo "============================================"
echo "   GREP DEMONSTRATIONS"
echo "============================================"

echo ""
echo "[ BASIC SEARCH ]"
echo "All ERROR lines:"
grep "ERROR" app.log

echo ""
echo "[ COUNT MATCHES ]"
echo "Number of ERROR lines:"
grep -c "ERROR" app.log

echo ""
echo "[ CASE INSENSITIVE ]"
echo "Search for 'warning' (any case):"
grep -i "warning" app.log

echo ""
echo "[ LINE NUMBERS ]"
echo "ERROR lines with line numbers:"
grep -n "ERROR" app.log

echo ""
echo "[ INVERT MATCH ]"
echo "Everything except INFO:"
grep -v "INFO" app.log

echo ""
echo "[ CONTEXT BEFORE ]"
echo "2 lines before each CRITICAL:"
grep -B 2 "CRITICAL" app.log

echo ""
echo "[ MULTIPLE PATTERNS ]"
echo "ERROR or CRITICAL lines:"
grep -E "ERROR|CRITICAL" app.log

echo ""
echo "============================================"
echo "   GREP COMPLETE"
echo "============================================"
