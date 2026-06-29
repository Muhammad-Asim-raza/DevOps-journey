#!/bin/bash
# ================================================
# conditions.sh — Making Decisions in Bash
# ================================================

# Basic if/else
DISK_USAGE=85

echo "[ DISK SPACE CHECK ]"
if [ $DISK_USAGE -gt 80 ]; then
    echo "⚠️  WARNING: Disk usage is $DISK_USAGE%"
    echo "    Please clean up old files!"
else
    echo "✅ Disk usage is fine: $DISK_USAGE%"
fi

# -gt means greater than
# -lt means less than
# -eq means equal to
# -ne means not equal to
# -ge means greater than or equal to
# -le means less than or equal to

echo ""
echo "[ SERVICE CHECK ]"
if systemctl is-active --quiet ssh; then
    echo "✅ SSH service is running"
else
    echo "❌ SSH service is NOT running"
    echo "   Starting SSH now..."
    sudo systemctl start ssh
fi

echo ""
echo "[ FILE CHECK ]"
FILE="/etc/hosts"
if [ -f $FILE ]; then
    echo "✅ File exists: $FILE"
else
    echo "❌ File not found: $FILE"
fi

# -f = check if file exists
# -d = check if directory exists
# -z = check if variable is empty

echo ""
echo "[ USER CHECK ]"
if [ "$USER" == "root" ]; then
    echo "⚠️  Running as root - be careful!"
else
    echo "✅ Running as normal user: $USER"
fi
