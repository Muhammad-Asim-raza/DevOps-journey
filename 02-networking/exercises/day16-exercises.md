# Day 16 Exercises — Load Balancing Deep Dive
**Date:** Jul 06 2026
**Status:** ✅ Completed

---

## Exercise 1: HAProxy Installation ✅
- [x] Installed HAProxy
- [x] Understood config structure
- [x] Configured frontend and backend
- [x] Set up stats dashboard
- [x] Configured health checks
- [x] Tested config with haproxy -c

### Proof
See: practices/day16-practice/exercise1-proof.txt

### HAProxy Config Sections
global   = process-level settings
defaults = applied to all sections
frontend = incoming traffic config
backend  = outgoing server config
listen   = combines frontend + backend

### Key Directives
bind *:8090        = listen on all IPs port 8090
balance roundrobin = distribution algorithm
option httpchk     = HTTP health check
server web1 IP:PORT check weight 3 = backend server
server web4 ... backup = standby server

---

## Exercise 2: Health Checks ✅
- [x] Understood TCP vs HTTP health checks
- [x] Learned health check best practices
- [x] Created health endpoint example
- [x] Configured health checks in HAProxy

### Proof
See: practices/day16-practice/exercise2-proof.txt

### Health Check Config
option httpchk GET /health
http-check expect status 200

### /health Endpoint Best Practices
✅ Return 200 when healthy
✅ Return 503 when unhealthy
✅ Check dependencies (DB cache)
✅ Respond within 1-2 seconds
✅ No authentication required
✅ Return JSON with status details

---

## Exercise 3: Sticky Sessions ✅
- [x] Understood why sticky sessions needed
- [x] Learned cookie-based sticky sessions
- [x] Understood IP hash alternative
- [x] Learned better: external session store

### Proof
See: practices/day16-practice/exercise3-proof.txt

### HAProxy Cookie Sticky Sessions
cookie SERVERID insert indirect nocache
server web1 ... cookie web1
server web2 ... cookie web2

### Better Alternative
Store sessions in Redis
Any server can read any session
No stickiness needed
No single point of failure

---

## Exercise 4: Scripts ✅
- [x] lb-simulator.sh - shows all algorithms
- [x] lb-health-monitor.sh - health checking

### Proof
See: practices/day16-practice/lb-simulator.sh
See: practices/day16-practice/lb-health-monitor.sh
See: practices/day16-practice/script-output-lb-simulator.txt
See: practices/day16-practice/script-output-health-monitor.txt

---

## Load Balancing Algorithms Summary

Round Robin    = equal distribution (default)
Weighted RR    = proportional by server power
Least Conn     = send to least busy (best for APIs)
IP Hash        = same client → same server
Random         = random selection
First          = fill first server before next

## Summary
All exercises completed on Jul 06 2026

Scripts written:
- lb-simulator.sh
- lb-health-monitor.sh

Proof files:
- exercise1-proof.txt (HAProxy)
- exercise2-proof.txt (health checks)
- exercise3-proof.txt (sticky sessions)
- exercise4-proof.txt (connection draining)
- exercise5-proof.txt (AWS LBs)
- script-output-lb-simulator.txt
- script-output-health-monitor.txt
