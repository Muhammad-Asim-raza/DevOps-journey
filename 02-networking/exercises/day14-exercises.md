# Day 14 Exercises — VPNs Network Monitoring Troubleshooting
**Date:** Jul 04 2026
**Status:** ✅ Completed

---

## Exercise 1: Ping Monitoring ✅
- [x] Pinged multiple hosts with statistics
- [x] Used -i flag for faster pinging
- [x] Saved results for multiple hosts

### Proof
See: practices/day14-practice/exercise1-proof.txt

### Key Commands
ping -c 4 google.com
ping -i 0.5 -c 20 host
ping -c 3 -W 2 host  (timeout 2 seconds)

### What I Learned
- -c = count packets
- -i = interval between packets
- -W = timeout per packet
- Shows: packet loss %, min/avg/max RTT
- Packet loss > 5% = network problem
- High RTT > 200ms = latency problem

---

## Exercise 2: Path Analysis ✅
- [x] Used traceroute to trace network path
- [x] Used mtr for combined analysis
- [x] Identified network hops and latency

### Proof
See: practices/day14-practice/exercise2-proof.txt

### Key Commands
traceroute -n google.com
mtr --report --report-cycles 10 google.com

### What I Learned
- traceroute shows every router hop
- Each hop adds latency
- * * * = router not responding (filtered)
- mtr = traceroute + ping combined
- mtr shows packet loss at each hop
- Latency spike at specific hop = problem there

---

## Exercise 3: Bandwidth Testing ✅
- [x] Installed iperf3
- [x] Started iperf3 server
- [x] Ran TCP bandwidth test
- [x] Ran UDP bandwidth test

### Proof
See: practices/day14-practice/exercise3-proof.txt

### Key Commands
iperf3 -s              (server)
iperf3 -c host -t 10   (TCP test)
iperf3 -c host -u -b 100M  (UDP test)

### What I Learned
- iperf3 measures actual network bandwidth
- TCP test shows throughput
- UDP test shows jitter and packet loss
- Jitter important for VoIP/video
- Compare to expected link speed

---

## Exercise 4: Connection Analysis ✅
- [x] Used ss -an for all connections
- [x] Counted connections by state
- [x] Found connections per remote IP
- [x] Checked listening ports

### Proof
See: practices/day14-practice/exercise4-proof.txt

### Key Commands
ss -an
ss -an | awk '{print $2}' | sort | uniq -c
ss -an | grep ESTABLISHED | awk '{print $5}'

### Connection States
LISTEN      = waiting for connections
ESTABLISHED = active connection
TIME_WAIT   = connection recently closed
CLOSE_WAIT  = local side closed waiting for remote

---

## Exercise 5: Packet Capture ✅
- [x] Installed tcpdump
- [x] Captured general traffic
- [x] Filtered by port
- [x] Filtered by host
- [x] Saved capture to file

### Proof
See: practices/day14-practice/exercise5-proof.txt

### Key Commands
sudo tcpdump -i any -c 20
sudo tcpdump port 80 -c 10
sudo tcpdump host 8.8.8.8 -c 5
sudo tcpdump -w capture.pcap

### What I Learned
- tcpdump captures raw network packets
- Requires root/sudo
- -i any = all interfaces
- Filters reduce noise
- .pcap files open in Wireshark (GUI)
- Essential for deep network debugging

---

## Exercise 6: Troubleshooting Methodology ✅
- [x] Followed OSI-based approach
- [x] Checked each layer systematically
- [x] Measured HTTP response timing
- [x] Used nc to test port connectivity

### Proof
See: practices/day14-practice/exercise6-proof.txt

### Troubleshooting Order
1. ip link show         (Layer 1/2 physical)
2. ip addr + ping GW    (Layer 3 network)
3. ss -tlnp + nc -zv    (Layer 4 transport)
4. curl + systemctl     (Layer 7 application)

### Timing Breakdown Command
curl -w "DNS:%{time_namelookup}s Connect:%{time_connect}s
         TTFB:%{time_starttransfer}s Total:%{time_total}s"
     -o /dev/null -s https://site.com

### What I Learned
- Always work bottom to top (OSI model)
- Find which layer is failing first
- nc -zv = test if port is open
- curl timing shows where slowness is
- DNS slow? Network slow? App slow?
- Each has different fix

---

## Exercise 7: Scripts ✅
- [x] network-monitor.sh checks all layers
- [x] port-scanner.sh audits open ports
- [x] networking-reference.sh complete guide
- [x] All outputs saved as proof

### Proof
See: practices/day14-practice/network-monitor.sh
See: practices/day14-practice/port-scanner.sh
See: practices/day14-practice/networking-reference.sh
See: practices/day14-practice/script-output-monitor.txt
See: practices/day14-practice/script-output-portscanner.txt
See: practices/day14-practice/script-output-reference.txt

---

## VPN Knowledge Summary ✅
Types learned:
- Remote Access VPN (individual → network)
- Site-to-Site VPN (network ↔ network)
- AWS Client VPN and Site-to-Site VPN
- WireGuard (modern fast protocol)
- OpenVPN (most compatible)

Why DevOps needs VPN:
- Secure database access without exposing ports
- Connect multi-cloud infrastructure
- Remote work secure access
- Internal service access

---

## NETWORKING PHASE COMPLETE SUMMARY
Days 11-14 Complete ✅

Day 11: OSI model TCP/IP DNS HTTP ports CIDR
Day 12: nginx reverse proxy load balancer
Day 13: SSL/TLS HTTPS Let's Encrypt certbot
Day 14: VPN network monitoring troubleshooting

All scripts written across networking phase:
- network-info.sh
- network-troubleshoot.sh
- nginx-manager.sh
- nginx-config-generator.sh
- ssl-checker.sh
- cert-monitor.sh
- networking-reference.sh
- network-monitor.sh
- port-scanner.sh

Skills I can demonstrate:
- Configure nginx as web server proxy LB
- Set up HTTPS with SSL/TLS
- Get free certificates with Let's Encrypt
- Troubleshoot network issues systematically
- Monitor network health automatically
- Analyze network traffic with tcpdump
- Test bandwidth with iperf3
- Audit open ports for security
