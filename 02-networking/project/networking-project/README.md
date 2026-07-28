# 🌐 Production-Ready Web Infrastructure
## DevOps Journey — Networking Phase Project
**Author:** Asim Raza  
**Day:** 18 of 120  
**Phase:** 2 — Networking (Days 11-18)

---

## 📋 Project Overview

A complete production-ready web infrastructure demonstrating
all networking concepts learned in Phase 2 of the DevOps journey.

### What This Project Builds
Internet Traffic
│
▼
[ Firewall (ufw + iptables) ]
│
▼
[ nginx Load Balancer + SSL/TLS ]
│
├──► Backend App 1 (port 3001)
├──► Backend App 2 (port 3002)
└──► Backend App 3 (port 3003)
│
▼
[ fail2ban Attack Protection ]
│
▼
[ Health Monitoring ]
---

## 🛠️ Technologies Used

| Technology | Purpose | Day Learned |
|---|---|---|
| nginx | Load balancer + reverse proxy | Day 12 |
| SSL/TLS | HTTPS encryption | Day 13 |
| iptables | Kernel firewall | Day 17 |
| ufw | Simplified firewall | Day 9 |
| fail2ban | Brute force protection | Day 17 |
| Python HTTP | Backend simulation | Day 18 |

---

## 📁 Project Structure
networking-project/
├── apps/
│ ├── app1/server.py ← Backend app on port 3001
│ ├── app2/server.py ← Backend app on port 3002
│ └── app3/server.py ← Backend app on port 3003
├── nginx/
│ ├── configs/
│ │ └── load-balancer.conf ← nginx config
│ └── ssl/
│ ├── server.crt ← SSL certificate
│ └── server.key ← Private key (gitignored)
├── scripts/
│ ├── deploy.sh ← Start everything
│ ├── stop.sh ← Stop everything
│ └── monitor.sh ← Health monitoring
├── proof/
│ ├── deploy-output.txt ← Deployment evidence
│ └── monitor-output.txt← Monitor evidence
└── README.md ← This file
---

## 🚀 How to Run

### Step 1: Start all backend apps and verify
```bash
bash scripts/deploy.sh
```

### Step 2: Monitor health
```bash
bash scripts/monitor.sh
```

### Step 3: Test load balancing
```bash
for i in {1..6}; do
    curl -k -s https://localhost:8443/ | python3 -m json.tool
done
```

### Step 4: Stop everything
```bash
bash scripts/stop.sh
```

---

## 🔍 Endpoints

| Endpoint | Description |
|---|---|
| `http://localhost:8080` | HTTP (redirects to HTTPS) |
| `https://localhost:8443` | HTTPS load balanced |
| `https://localhost:8443/health` | Backend health check |
| `https://localhost:8443/nginx-health` | nginx health check |
| `https://localhost:8443/api` | API endpoint |
| `https://localhost:8443/info` | Server info |

---

## 🔒 Security Features

- ✅ HTTPS with TLS 1.2 and 1.3 only
- ✅ HTTP to HTTPS redirect (301)
- ✅ Security headers (HSTS, X-Frame-Options, etc)
- ✅ fail2ban SSH brute force protection
- ✅ ufw firewall (default deny)
- ✅ iptables rules
- ✅ Sensitive file blocking
- ✅ nginx version hidden

---

## ⚖️ Load Balancing

**Algorithm:** Round Robin (equal distribution)

**Servers:**
- App-1: 127.0.0.1:3001 (weight=1)
- App-2: 127.0.0.1:3002 (weight=1)  
- App-3: 127.0.0.1:3003 (weight=1)

**Health Check:** GET /health → HTTP 200

**Failover:** proxy_next_upstream error timeout
(automatic retry on next server if one fails)

---

## 📊 Concepts Demonstrated

This project demonstrates knowledge from all 7 networking days:

| Day | Topic | Where Used |
|---|---|---|
| Day 11 | TCP/IP DNS HTTP | nginx HTTP handling |
| Day 12 | nginx reverse proxy | Load balancer config |
| Day 13 | SSL/TLS HTTPS | Self-signed cert + HTTPS |
| Day 14 | Network monitoring | monitor.sh script |
| Day 15 | Subnetting VPC | Architecture planning |
| Day 16 | Load balancing | upstream block + weights |
| Day 17 | Security iptables fail2ban | Security layer |

---

## 🎯 Interview Talking Points

> "I built a production-ready web infrastructure featuring
> nginx as a Layer 7 load balancer with SSL termination,
> distributing traffic across three backend services using
> round-robin algorithm with health checks and automatic
> failover. The security layer includes ufw and iptables
> firewall rules, fail2ban for brute-force protection,
> and nginx security headers. I wrote deployment and
> monitoring scripts to automate operations."
