#!/bin/bash
# ================================================
# iptables-setup.sh
# Production Firewall Setup Script
# Author: Asim Raza
# Day 17 of DevOps Journey
# RUN WITH: sudo bash iptables-setup.sh
# ================================================

echo "============================================"
echo "   IPTABLES FIREWALL SETUP"
echo "   Author: Asim Raza - Day 17"
echo "============================================"

# ── SAFETY: Flush existing rules first ──
echo ""
echo "[ STEP 1: Flushing existing rules ]"
iptables -F                  # flush all chains
iptables -X                  # delete custom chains
iptables -t nat -F           # flush nat table
iptables -t mangle -F        # flush mangle table
echo "✅ Existing rules cleared"

# ── SET DEFAULT POLICIES ──
echo ""
echo "[ STEP 2: Setting default policies ]"
iptables -P INPUT DROP       # block all incoming
iptables -P FORWARD DROP     # block forwarding
iptables -P OUTPUT ACCEPT    # allow all outgoing
echo "✅ Default: INPUT=DROP, FORWARD=DROP, OUTPUT=ACCEPT"

# ── ALLOW LOOPBACK ──
echo ""
echo "[ STEP 3: Allowing loopback interface ]"
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
echo "✅ Loopback (127.0.0.1) allowed"

# ── ALLOW ESTABLISHED CONNECTIONS ──
echo ""
echo "[ STEP 4: Allowing established connections ]"
iptables -A INPUT -m state \
    --state ESTABLISHED,RELATED -j ACCEPT
echo "✅ Established/Related connections allowed"

# ── ALLOW ICMP (PING) ──
echo ""
echo "[ STEP 5: Allowing ICMP (ping) ]"
iptables -A INPUT -p icmp \
    --icmp-type echo-request \
    -m limit --limit 5/s \
    -j ACCEPT
# -m limit --limit 5/s = max 5 pings per second
# prevents ping flood attacks
echo "✅ ICMP ping allowed (rate limited: 5/sec)"

# ── ALLOW SSH WITH BRUTE FORCE PROTECTION ──
echo ""
echo "[ STEP 6: Allowing SSH with brute force protection ]"
iptables -A INPUT -p tcp --dport 22 \
    -m state --state NEW \
    -m recent --set --name SSH_ATTACK
iptables -A INPUT -p tcp --dport 22 \
    -m state --state NEW \
    -m recent --update \
    --seconds 60 --hitcount 4 \
    --name SSH_ATTACK \
    -j LOG --log-prefix "SSH_BRUTE_FORCE: "
iptables -A INPUT -p tcp --dport 22 \
    -m state --state NEW \
    -m recent --update \
    --seconds 60 --hitcount 4 \
    --name SSH_ATTACK \
    -j DROP
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
echo "✅ SSH port 22 allowed (max 3 attempts per 60 sec)"

# ── ALLOW HTTP AND HTTPS ──
echo ""
echo "[ STEP 7: Allowing HTTP and HTTPS ]"
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
echo "✅ HTTP (80) and HTTPS (443) allowed"

# ── ALLOW CUSTOM PORTS ──
echo ""
echo "[ STEP 8: Allowing application ports ]"
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 8443 -j ACCEPT
iptables -A INPUT -p tcp --dport 8090 -j ACCEPT
# HAProxy stats
iptables -A INPUT -p tcp --dport 8404 \
    -s 127.0.0.1 -j ACCEPT
echo "✅ App ports (8080 8443 8090) allowed"
echo "✅ HAProxy stats (8404) localhost only"

# ── BLOCK COMMON ATTACKS ──
echo ""
echo "[ STEP 9: Blocking common attacks ]"

# Block NULL packets
iptables -A INPUT -p tcp \
    --tcp-flags ALL NONE -j DROP
echo "✅ NULL packet scan blocked"

# Block XMAS packets (Christmas tree attack)
iptables -A INPUT -p tcp \
    --tcp-flags ALL ALL -j DROP
echo "✅ XMAS packet scan blocked"

# Block SYN flood
iptables -A INPUT -p tcp ! --syn \
    -m state --state NEW -j DROP
echo "✅ SYN flood protection enabled"

# Block fragments
iptables -A INPUT -f -j DROP
echo "✅ Fragmented packet attack blocked"

# ── LOG DROPPED PACKETS ──
echo ""
echo "[ STEP 10: Setting up logging ]"
iptables -A INPUT -j LOG \
    --log-prefix "IPTABLES_DROP: " \
    --log-level 4
echo "✅ Dropped packets logged to syslog"

# ── SHOW FINAL RULES ──
echo ""
echo "[ FINAL FIREWALL RULES ]"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
iptables -L -n -v --line-numbers
echo ""
echo "============================================"
echo "   FIREWALL SETUP COMPLETE ✅"
echo "============================================"
echo ""
echo "Open ports: 22 (SSH) 80 (HTTP) 443 (HTTPS)"
echo "           8080 8443 8090 (apps)"
echo "Blocked:   everything else"
echo ""
echo "To save rules permanently:"
echo "sudo apt install iptables-persistent"
echo "sudo netfilter-persistent save"
