#!/bin/bash
# ================================================
# sed-practice.sh
# sed Find and Replace Demonstrations
# Author: Asim Raza
# Day 7 of DevOps Journey
# ================================================

echo "============================================"
echo "   SED DEMONSTRATIONS"
echo "============================================"

echo ""
echo "[ FIND AND REPLACE ]"
echo "Replace ERROR with ALERT:"
sed 's/ERROR/ALERT/g' app.log | grep "ALERT"

echo ""
echo "[ DELETE MATCHING LINES ]"
echo "Remove all INFO lines:"
sed '/INFO/d' app.log

echo ""
echo "[ PRINT LINE RANGE ]"
echo "Show only lines 5 to 10:"
sed -n '5,10p' app.log

echo ""
echo "[ REDACT SENSITIVE DATA ]"
echo "Hide IP addresses:"
sed 's/192\.168\.[0-9]*\.[0-9]*/REDACTED/g' app.log | grep "REDACTED"

echo ""
echo "[ PRINT ONLY MATCHING ]"
echo "Print only ERROR lines using sed:"
sed -n '/ERROR/p' app.log

echo ""
echo "============================================"
echo "   SED COMPLETE"
echo "============================================"
