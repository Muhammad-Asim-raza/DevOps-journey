#!/bin/bash
# ================================================
# ssh-checker.sh
# SSH Key Checker and Status Reporter
# Author: Asim Raza
# Day 5 of DevOps Journey
# ================================================

echo "============================================"
echo "   SSH STATUS REPORT"
echo "   Generated: $(date)"
echo "============================================"

echo ""
echo "[ CHECKING SSH DIRECTORY ]"
if [ -d ~/.ssh ]; then
    echo "✅ SSH directory exists: ~/.ssh"
else
    echo "❌ SSH directory missing"
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    echo "✅ Created ~/.ssh directory"
fi

echo ""
echo "[ CHECKING SSH KEYS ]"
if [ -f ~/.ssh/id_ed25519 ]; then
    echo "✅ Private key: ~/.ssh/id_ed25519"
else
    echo "❌ No private key found"
fi

if [ -f ~/.ssh/id_ed25519.pub ]; then
    echo "✅ Public key:  ~/.ssh/id_ed25519.pub"
else
    echo "❌ No public key found"
fi

echo ""
echo "[ KEY PERMISSIONS ]"
ls -la ~/.ssh/

echo ""
echo "[ YOUR PUBLIC KEY ]"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat ~/.ssh/id_ed25519.pub
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo ""
echo "[ CHECKING SSH CONFIG ]"
if [ -f ~/.ssh/config ]; then
    echo "✅ SSH config exists"
    echo "   Your configured shortcuts:"
    grep "^Host" ~/.ssh/config
else
    echo "⚠️  No SSH config file found"
fi

echo ""
echo "[ TESTING GITHUB CONNECTION ]"
ssh -T git@github.com 2>&1

echo ""
echo "============================================"
echo "   REPORT COMPLETE"
echo "============================================"
