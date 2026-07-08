#!/bin/bash
# ================================================
# user-manager.sh
# User and Group Management Reference
# Author: Asim Raza
# Day 9 of DevOps Journey
# ================================================

echo "============================================"
echo "   USER AND GROUP MANAGER"
echo "   Generated: $(date)"
echo "============================================"

echo ""
echo "[ CURRENT USER INFO ]"
echo "Username : $(whoami)"
echo "User ID  : $(id -u)"
echo "Group ID : $(id -g)"
echo "Groups   : $(groups)"

echo ""
echo "[ ALL USERS ON SYSTEM ]"
echo "Regular users (UID >= 1000):"
awk -F: '$3 >= 1000 {print $1, "UID:"$3, "Shell:"$7}' /etc/passwd

echo ""
echo "[ ALL GROUPS ]"
echo "Groups on this system:"
cat /etc/group | grep -v "^#" | cut -d: -f1,3 | head -20

echo ""
echo "[ SUDO USERS ]"
echo "Users with sudo access:"
getent group sudo | cut -d: -f4

echo ""
echo "[ LOGGED IN USERS ]"
who

echo ""
echo "[ RECENT LOGINS ]"
last | head -10

echo ""
echo "[ FAILED LOGIN ATTEMPTS ]"
sudo grep "Failed password" /var/log/auth.log 2>/dev/null | tail -5 || echo "No failed attempts found"

echo ""
echo "============================================"
echo "   USER REPORT COMPLETE"
echo "============================================"
