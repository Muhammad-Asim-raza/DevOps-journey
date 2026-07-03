#!/bin/bash
# ================================================
# awk-practice.sh
# awk Column Extraction Demonstrations
# Author: Asim Raza
# Day 7 of DevOps Journey
# ================================================

echo "============================================"
echo "   AWK DEMONSTRATIONS"
echo "============================================"

echo ""
echo "[ EXTRACT DATE COLUMN ]"
echo "First column only:"
awk '{print $1}' app.log | head -5

echo ""
echo "[ EXTRACT DATE TIME LEVEL ]"
echo "First three columns:"
awk '{print $1, $2, $3}' app.log | head -5

echo ""
echo "[ COUNT LOG LEVELS ]"
echo "How many of each level:"
awk '{print $3}' app.log | sort | uniq -c | sort -rn

echo ""
echo "[ FILTER BY CONDITION ]"
echo "Only ERROR lines:"
awk '$3 == "ERROR" {print}' app.log

echo ""
echo "[ COUNT WITH AWK ]"
echo "Total error count:"
awk '$3 == "ERROR" {count++} END {print "Total errors:", count}' app.log

echo ""
echo "[ ADD LINE NUMBERS ]"
echo "Lines with numbers:"
awk '{print NR, $0}' app.log | head -5

echo ""
echo "============================================"
echo "   AWK COMPLETE"
echo "============================================"
