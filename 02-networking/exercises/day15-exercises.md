# Day 15 Exercises — Subnetting and VPC Deep Dive
**Date:** Jul 05 2026
**Status:** ✅ Completed

---

## Exercise 1: IP Address and Binary ✅
- [x] Understood binary representation of IPs
- [x] Converted decimals to binary
- [x] Identified network vs host bits

### Key Concept
192.168.1.0/24 in binary:
11000000.10101000.00000001.00000000
Network(24 bits)────────────────Host(8 bits)

### Decimal to Binary Values
128  64  32  16  8  4  2  1
Memory: "Big Cats Don't Lose Fights But Still Run"

### Proof
See: practices/day15-practice/exercise1-proof.txt

---

## Exercise 2: CIDR Calculations ✅
- [x] Calculated network address
- [x] Calculated broadcast address
- [x] Found usable IP range
- [x] Determined subnet mask

### Formula
Hosts = 2^(32-prefix) - 2

### Examples Calculated
/24 = 256 addresses, 254 usable
/26 = 64 addresses, 62 usable
/16 = 65,536 addresses, 65,534 usable

### Proof
See: practices/day15-practice/script-output-subnet.txt

---

## Exercise 3: Subnet Script ✅
- [x] subnet-calculator.sh written
- [x] Calculates all subnet details
- [x] Shows CIDR reference table
- [x] Includes VPC design example

### Proof
See: practices/day15-practice/subnet-calculator.sh
See: practices/day15-practice/script-output-subnet.txt

---

## Exercise 4: VPC Architecture ✅
- [x] Designed complete VPC with 6 subnets
- [x] Configured route tables for each tier
- [x] Designed security groups
- [x] Mapped traffic flows

### VPC Design Created
VPC: 10.0.0.0/16

Subnets:
- Public A/B: 10.0.1.0/24 and 10.0.2.0/24
- Private A/B: 10.0.10.0/24 and 10.0.11.0/24
- Database A/B: 10.0.20.0/26 and 10.0.21.0/26

Route Tables:
- Public: 0.0.0.0/0 → Internet Gateway
- Private: 0.0.0.0/0 → NAT Gateway
- Database: local only (no internet)

### Proof
See: practices/day15-practice/vpc-designer.sh
See: practices/day15-practice/script-output-vpc.txt

---

## Key Concepts Learned

### CIDR Cheat Sheet
/32 = 1 IP (specific host)
/24 = 254 hosts (most common subnet)
/16 = 65,534 hosts (VPC typical)
/8  = 16M hosts (large private range)
0.0.0.0/0 = all addresses

### Private IP Ranges (RFC 1918)
10.0.0.0/8      = Class A (large)
172.16.0.0/12   = Class B (medium) Docker
192.168.0.0/16  = Class C (home/office)

### VPC Components
Internet Gateway = connects VPC to internet
NAT Gateway      = private subnet outbound only
Public Subnet    = has route to IGW
Private Subnet   = has route to NAT GW
DB Subnet        = no internet route at all
Security Groups  = stateful instance firewall
NACLs           = stateless subnet firewall

### Security Groups vs NACLs
SG:   stateful, instance level, allow only
NACL: stateless, subnet level, allow and deny

---

## Summary
All exercises completed on Jul 05 2026

Scripts written:
- subnet-calculator.sh
- vpc-designer.sh

Proof files:
- exercise1-proof.txt
- exercise2-proof.txt
- script-output-subnet.txt
- script-output-vpc.txt
