# Day 17 Exercises — Network Security Deep Dive
**Date:** Jul 07 2026
**Status:** ✅ Completed

---

## Exercise 1: Production Firewall ✅
- [x] Built complete firewall from scratch
- [x] Set default DROP policy
- [x] Allowed SSH with brute force protection
- [x] Allowed HTTP and HTTPS
- [x] Blocked common attack patterns

### Proof
See: practices/day17-practice/exercise1-proof.txt
See: practices/day17-practice/iptables-setup.sh
See: practices/day17-practice/script-output-iptables.txt

### Key Rules Added
- Allow loopback (localhost)
- Allow ESTABLISHED connections
- Allow ICMP (rate limited)
- Allow SSH (max 3 attempts/60 sec)
- Allow HTTP/HTTPS (80/443)
- Block NULL/XMAS/SYN flood packets
- Log dropped packets

---

## Exercise 2: iptables Persistence ✅
- [x] Learned rules are lost on reboot
- [x] Installed iptables-persistent
- [x] Saved rules with netfilter-persistent
- [x] Verified saved rules file

### Proof
See: practices/day17-practice/exercise2-proof.txt

### Persistence Commands
sudo apt install iptables-persistent
sudo netfilter-persistent save
sudo iptables-save > /etc/iptables/rules.v4
sudo iptables-restore < /etc/iptables/rules.v4

---

## Exercise 3: fail2ban ✅
- [x] Installed fail2ban
- [x] Created jail.local config
- [x] Configured SSH jail (3 attempts/24h ban)
- [x] Configured nginx jail
- [x] Checked jail status
- [x] Learned ban/unban commands

### Proof
See: practices/day17-practice/exercise3-proof.txt

### Key fail2ban Config
[DEFAULT]
bantime  = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled  = true
maxretry = 3
bantime  = 24h

### Management Commands
sudo fail2ban-client status
sudo fail2ban-client status sshd
sudo fail2ban-client set sshd banip IP
sudo fail2ban-client set sshd unbanip IP

---

## Exercise 4: WAF Concepts ✅
- [x] Understood WAF vs regular firewall
- [x] Learned OWASP Top 10 attacks
- [x] Created basic nginx WAF rules
- [x] Learned AWS WAF concepts

### Proof
See: practices/day17-practice/exercise4-proof.txt

### WAF Protects Against
SQL injection, XSS, path traversal
Command injection, sensitive file access
Vulnerability scanners

### Implementation Options
1. ModSecurity (open source)
2. nginx custom rules (basic)
3. AWS WAF (managed, costly)
4. Cloudflare WAF (free tier available)

---



## Exercise 5: Security Audit Script ✅
- [x] security-audit.sh written
- [x] Checks firewall, SSH, fail2ban
- [x] Checks exposed ports
- [x] Gives security score

### Proof
See: practices/day17-practice/security-audit.sh
See: practices/day17-practice/script-output-audit.txt

---

## Summary
All 5 exercises completed on Jul 07 2026

Scripts written:
- iptables-setup.sh (production firewall)
- security-audit.sh (security checker)

Proof files:
- exercise1-proof.txt (production firewall)
- exercise2-proof.txt (persistence)
- exercise3-proof.txt (fail2ban)
- exercise4-proof.txt (WAF)
- script-output-iptables.txt
- script-output-audit.txt
