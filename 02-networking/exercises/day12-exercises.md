# Day 12 Exercises — Load Balancers Reverse Proxies nginx
**Date:** Jul 02 2026
**Status:** ✅ Completed

---

## Exercise 1: nginx Installation ✅
- [x] Installed nginx with apt
- [x] Verified version with nginx -v
- [x] Checked service status
- [x] Tested default page with curl

### Proof
See: practices/day12-practice/exercise1-proof.txt

### Key Commands
sudo apt install nginx -y
nginx -v
sudo systemctl status nginx
curl http://localhost

### What I Learned
- nginx installs as a systemd service
- Default page served on port 80
- Config files in /etc/nginx/
- Log files in /var/log/nginx/
- Web files in /var/www/html/

---

## Exercise 2: Static File Server ✅
- [x] Created custom website directory
- [x] Wrote HTML page
- [x] Created nginx site config
- [x] Used sites-available and sites-enabled
- [x] Tested with nginx -t before reload
- [x] Reloaded nginx with systemctl reload

### Proof
See: practices/day12-practice/exercise2-proof.txt

### Config Location
/etc/nginx/sites-available/devops-site

### Key nginx Directives Learned
listen = which port to listen on
server_name = which hostname to match
root = where files are located
index = default file to serve
location / = how to handle requests
try_files = look for file then directory then 404
expires = browser cache duration
error_page = custom error pages

### What I Learned
- sites-available = all configured sites
- sites-enabled = active sites (symlinks)
- ln -s = create symbolic link to enable
- nginx -t = ALWAYS test before reload
- systemctl reload = zero downtime config reload

---

## Exercise 3: Reverse Proxy ✅
- [x] Created Python backend servers
- [x] Created nginx reverse proxy config
- [x] Used proxy_pass directive
- [x] Set proxy headers correctly
- [x] Configured timeouts

### Proof
See: practices/day12-practice/exercise3-proof.txt

### Key nginx Directives
proxy_pass = forward to this backend URL
proxy_set_header Host = pass original hostname
proxy_set_header X-Real-IP = pass client IP
proxy_connect_timeout = connection timeout
proxy_read_timeout = response timeout
upstream = define backend server group

### What I Learned
- Reverse proxy hides backend from internet
- proxy_pass forwards requests transparently
- Headers must be forwarded manually
- Without X-Real-IP backend sees nginx IP not client
- Timeouts prevent hanging connections

---

## Exercise 4: Load Balancer ✅
- [x] Created multiple backend servers
- [x] Created upstream block with weights
- [x] Configured round_robin (default)
- [x] Added backup server
- [x] Added health check endpoint
- [x] Tested distribution across backends

### Proof
See: practices/day12-practice/exercise4-proof.txt

### Load Balancing Algorithms
round_robin = equal distribution (default)
least_conn  = send to least busy server
ip_hash     = same client → same server

### upstream Directives
weight=3    = gets 3x more traffic
backup      = only used when all others fail
proxy_next_upstream = try next if error

### What I Learned
- upstream block defines server pool
- weight balances unequal capacity servers
- backup provides automatic failover
- proxy_next_upstream = transparent failover
- /health endpoint for monitoring systems

---

## Exercise 5: nginx Logs ✅
- [x] Read access log format
- [x] Analyzed logs with awk and grep
- [x] Found status code distribution
- [x] Found top requested URLs
- [x] Identified error patterns

### Proof
See: practices/day12-practice/exercise5-proof.txt

### Log Analysis Commands
awk '{print $9}' access.log | sort | uniq -c
awk '{print $7}' access.log | sort | uniq -c | head -10
grep " 404 " access.log
awk '{print $1}' access.log | sort | uniq -c | sort -rn

### Log Fields
$1 = client IP
$4 = timestamp
$6 = HTTP method
$7 = URL path
$9 = status code
$10 = response size

---

## Exercise 6: Scripts ✅
- [x] nginx-manager.sh written and working
- [x] nginx-config-generator.sh written and working
- [x] Generated 5 production-ready configs
- [x] All outputs saved as proof

### Proof
See: practices/day12-practice/nginx-manager.sh
See: practices/day12-practice/nginx-config-generator.sh
See: practices/day12-practice/nginx-configs/ (5 configs)
See: practices/day12-practice/script-output-nginx.txt
See: practices/day12-practice/script-output-generator.txt

---

## Summary
All 6 exercises completed on Jul 02 2026

Scripts written:
- nginx-manager.sh
- nginx-config-generator.sh
- backend-server.sh

nginx Configs generated:
- static-site.conf
- reverse-proxy.conf
- load-balancer.conf
- https-redirect.conf
- microservices.conf

Proof files:
- exercise1-proof.txt (installation)
- exercise2-proof.txt (static site)
- exercise3-proof.txt (reverse proxy)
- exercise4-proof.txt (load balancer)
- exercise5-proof.txt (log analysis)
- script-output-nginx.txt
- script-output-generator.txt

Key concepts learned:
- Reverse proxy (hide backends expose one entry)
- Load balancer (distribute traffic)
- nginx installation and configuration
- Virtual hosts (sites-available/sites-enabled)
- nginx directives (listen root proxy_pass upstream)
- Load balancing algorithms
- Security headers
- nginx log analysis
