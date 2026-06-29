#!/bin/bash
# ================================================
# loops.sh — Repeating Actions in Bash
# ================================================

echo "[ FOR LOOP — Fixed list ]"
for SERVER in web-01 web-02 web-03 db-01 db-02
do
    echo "Checking server: $SERVER"
done
# for   = start loop
# SERVER = variable that changes each time
# in    = the list of values
# do    = start the loop body
# done  = end the loop

echo ""
echo "[ FOR LOOP — Numbers ]"
for NUMBER in 1 2 3 4 5
do
    echo "Backup $NUMBER completed ✅"
done

echo ""
echo "[ FOR LOOP — Range ]"
for i in {1..5}
do
    echo "Day $i of DevOps journey"
done
# {1..5} = numbers from 1 to 5

echo ""
echo "[ WHILE LOOP ]"
COUNT=1
while [ $COUNT -le 5 ]
do
    echo "Running health check $COUNT of 5"
    COUNT=$((COUNT + 1))
done
# while = keep looping while condition is true
# $((COUNT + 1)) = add 1 to COUNT each time

echo ""
echo "[ REAL DEVOPS EXAMPLE ]"
echo "Checking disk space on multiple servers..."
for SERVER in web-server db-server cache-server
do
    echo "━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Server  : $SERVER"
    echo "Status  : Checking..."
    echo "Disk    : $(df -h / | tail -1 | awk '{print $5}') used"
    echo "Memory  : $(free -h | awk '/^Mem:/ {print $3}') used"
done
