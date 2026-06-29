#!/bin/bash
# ================================================
# variables.sh — Learning Bash Variables
# ================================================

# Storing values in variables
NAME="Asim"
COURSE="DevOps"
DAY=4
SERVER="production-server-01"

# Using variables with $
echo "Student name : $NAME"
echo "Course       : $COURSE"
echo "Day number   : $DAY"
echo "Server name  : $SERVER"

# Variables in sentences
echo ""
echo "$NAME is on Day $DAY of $COURSE journey!"

# Special variables Linux gives you automatically
echo ""
echo "[ AUTOMATIC VARIABLES ]"
echo "Current user     : $USER"
echo "Home directory   : $HOME"
echo "Current directory: $PWD"
echo "Computer hostname: $HOSTNAME"

# Storing command output in variable
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}')
echo ""
echo "[ COMMAND OUTPUT IN VARIABLE ]"
echo "Disk usage: $DISK_USAGE"

RAM_FREE=$(free -h | awk '/^Mem:/ {print $4}')
echo "Free RAM  : $RAM_FREE"
