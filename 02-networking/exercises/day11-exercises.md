# Day 11 Exercises — Networking Fundamentals
**Date:** Jul 01 2026
**Status:** ✅ Completed

---

## Exercise 1: ping — Test Connectivity ✅
- [x] Pinged google.com
- [x] Pinged 8.8.8.8 (Google DNS)
- [x] Pinged 127.0.0.1 (loopback)
- [x] Used -c 4 to limit packets

### Proof
See: practices/day11-practice/exercise1-proof.txt

### Key Commands
ping -c 4 google.com
ping -c 4 8.8.8.8
ping -c 2 127.0.0.1

### What I Learned
- ping tests if host is reachable
- ICMP protocol (not TCP or UDP)
- Round trip time shows network latency
- 127.0.0.1 always works (loopback)
- -c limits number of packets sent

---

## Exercise 2: curl — HTTP from Terminal ✅
- [x] Made basic HTTP request
- [x] Checked headers with -I
- [x] Got HTTP status code only
- [x] Tested public API

### Proof
See: practices/day11-practice/exercise2-proof.txt

### Key Commands
curl google.com
curl -I https://google.com
curl -o /dev/null -s -w "%{http_code}\n" https://google.com
curl -s https://httpbin.org/ip

### What I Learned
- curl makes HTTP requests from terminal
- -I = headers only (HEAD request)
- -s = silent (no progress output)
- -L = follow redirects
- -v = verbose (see full request/response)
- -X = specify HTTP method
- -H = add request header
- -d = send request body data

---

## Exercise 3: DNS Lookup ✅
- [x] Used nslookup to resolve domains
- [x] Used dig for detailed DNS info
- [x] Queried MX records
- [x] Used specific DNS server with @

### Proof
See: practices/day11-practice/exercise3-proof.txt

### Key Commands
nslookup google.com
dig google.com +short
dig google.com MX +short
dig @8.8.8.8 github.com +short

### DNS Record Types I Learned
A     = domain → IPv4 address
AAAA  = domain → IPv6 address
CNAME = domain → another domain (alias)
MX    = mail server records
NS    = nameserver records
TXT   = text records (verification)
PTR   = IP → domain (reverse DNS)

---

## Exercise 4: Network Connections ✅
- [x] Listed all listening ports with ss -tlnp
- [x] Checked connection summary with ss -s
- [x] Found which process uses which port

### Proof
See: practices/day11-practice/exercise4-proof.txt

### Key Commands
ss -tlnp
ss -tlnp | grep :80
ss -s
ss -an

### What I Learned
- ss = socket statistics (modern netstat)
- -t = TCP only
- -l = listening ports
- -n = numeric (not service names)
- -p = show process name and PID
- Port 22 = SSH, Port 80 = HTTP, 443 = HTTPS

---

## Exercise 5: IP and Routes ✅
- [x] Checked IP addresses with ip addr
- [x] Viewed routing table with ip route
- [x] Identified private vs public IP

### Proof
See: practices/day11-practice/exercise5-proof.txt

### Key Commands
ip addr show
ip route show
hostname -I
curl -s https://ifconfig.me

### What I Learned
- ip addr = show network interfaces and IPs
- ip route = show how traffic is routed
- Private IPs: 10.x.x.x 172.16-31.x.x 192.168.x.x
- Public IP: everything else
- Default route = gateway for internet traffic
- Loopback: 127.0.0.1 = localhost = yourself

---

## Exercise 6: Network Scripts ✅
- [x] network-info.sh written and working
- [x] network-troubleshoot.sh written and working
- [x] Both outputs saved as proof

### Proof
See: practices/day11-practice/network-info.sh
See: practices/day11-practice/network-troubleshoot.sh
See: practices/day11-practice/script-output-network.txt
See: practices/day11-practice/script-output-troubleshoot.txt

### Troubleshooting Steps Script Covers
1. Network interface UP/DOWN check
2. IP address assigned check
3. Default gateway check
4. Gateway reachability test
5. External IP reachability test
6. DNS resolution test
7. HTTP connectivity test
8. Open ports check

---

## Key Concepts I Learned Today

### OSI Model (7 Layers)
7 Application  = HTTP HTTPS DNS FTP
6 Presentation = SSL/TLS encryption
5 Session      = Connection management
4 Transport    = TCP UDP ports
3 Network      = IP addresses routing
2 Data Link    = MAC addresses switches
1 Physical     = Cables WiFi signals

Memory trick: "All People Seem To Need Data Processing"

### TCP vs UDP
TCP = reliable ordered guaranteed delivery
      Used for: HTTP SSH databases APIs
UDP = fast unreliable no guarantee
      Used for: DNS video gaming VoIP

### CIDR Notation
/32 = one IP address
/24 = 256 addresses
/16 = 65,536 addresses
/8  = 16 million addresses
0.0.0.0/0 = all addresses (anywhere)

### Important Ports
22   = SSH
80   = HTTP
443  = HTTPS
3306 = MySQL
5432 = PostgreSQL
6379 = Redis
8080 = Alternative HTTP / Jenkins
27017 = MongoDB

### HTTP Status Codes
2xx = Success (200 OK 201 Created)
3xx = Redirect (301 302)
4xx = Client error (404 Not Found 403 Forbidden)
5xx = Server error (500 502 503 504)

---

## Summary
All 6 exercises completed on Jul 01 2026

Scripts written:
- network-info.sh (network status report)
- network-troubleshoot.sh (step by step debug)

Proof files:
- exercise1-proof.txt (ping tests)
- exercise2-proof.txt (curl HTTP tests)
- exercise3-proof.txt (DNS lookups)
- exercise4-proof.txt (port listings)
- exercise5-proof.txt (IP and routes)
- script-output-network.txt
- script-output-troubleshoot.txt

Key networking concepts learned:
- OSI model 7 layers
- TCP vs UDP
- IP addresses (private public loopback)
- CIDR notation
- Ports and well-known port numbers
- DNS and record types
- HTTP methods and status codes
- HTTPS and SSL/TLS handshake
- ping curl nslookup dig ss ip wget commands
