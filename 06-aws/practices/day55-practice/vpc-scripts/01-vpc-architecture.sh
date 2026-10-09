#!/bin/bash
# ================================================
# 01-vpc-architecture.sh
# VPC Architecture Reference
# Author: Asim Raza - Day 55
# ================================================

echo "============================================"
echo "   AWS VPC ARCHITECTURE"
echo "   Author: Asim Raza - Day 55"
echo "============================================"

echo ""
echo "[ PRODUCTION 3-TIER VPC ARCHITECTURE ]"
cat << 'DIAGRAM'

  INTERNET
     │
     ▼
┌─────────────────────────────────────────────────┐
│  INTERNET GATEWAY                               │
│  (front door - connects VPC to internet)        │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│  VPC: 10.0.0.0/16   (us-east-1)                │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │  PUBLIC SUBNETS (internet-reachable)       │ │
│  │  AZ-a: 10.0.1.0/24  AZ-b: 10.0.2.0/24   │ │
│  │                                            │ │
│  │  [ALB]    [NAT GW]    [Bastion Host]      │ │
│  │  (Load    (private→   (SSH access         │ │
│  │  Balance) internet)   for admin)          │ │
│  └────────────┬────────────────────────────── ┘ │
│               │ private traffic only             │
│  ┌────────────▼───────────────────────────────┐ │
│  │  PRIVATE SUBNETS (NOT internet-reachable)  │ │
│  │  AZ-a: 10.0.10.0/24 AZ-b: 10.0.11.0/24  │ │
│  │                                            │ │
│  │  [EC2 App]  [ECS Tasks]  [Lambda]         │ │
│  │  (Application layer - no public IPs)      │ │
│  └────────────┬───────────────────────────────┘ │
│               │ DB traffic only                  │
│  ┌────────────▼───────────────────────────────┐ │
│  │  DATABASE SUBNETS (most restricted)        │ │
│  │  AZ-a: 10.0.20.0/24 AZ-b: 10.0.21.0/24  │ │
│  │                                            │ │
│  │  [RDS Primary]    [RDS Standby]           │ │
│  │  (Database - only reachable from app)     │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
└──────────────────────────────────────────────────┘

TRAFFIC FLOWS:
Internet → ALB (public subnet) → EC2 (private subnet) → RDS (db subnet)
EC2 (private) → NAT Gateway (public) → Internet (updates, APIs)
Admin → Bastion Host (public, SSH) → EC2 (private, SSH)
DIAGRAM

echo ""
echo "[ VPC COMPONENTS EXPLAINED ]"
echo ""
echo "  VPC (Virtual Private Cloud):"
echo "  Your isolated private network in AWS"
echo "  CIDR: 10.0.0.0/16 (65,536 IPs)"
echo "  Region-scoped (VPC in us-east-1 stays there)"
echo ""
echo "  Subnets:"
echo "  Sub-division of VPC CIDR"
echo "  AZ-scoped (subnet lives in one AZ)"
echo "  Public subnet: has route to Internet Gateway"
echo "  Private subnet: NO route to Internet Gateway"
echo ""
echo "  Internet Gateway (IGW):"
echo "  Allows VPC ↔ Internet communication"
echo "  One per VPC"
echo "  Attached to VPC, not a subnet"
echo "  Required for ANY internet access"
echo ""
echo "  NAT Gateway:"
echo "  Private instances → Internet (outbound only)"
echo "  Internet cannot initiate connections inward"
echo "  Lives in PUBLIC subnet"
echo "  Private subnet routes 0.0.0.0/0 → NAT GW"
echo "  Used for: downloading updates, calling APIs"
echo "  Cost: \$0.045/hour + \$0.045/GB processed"
echo ""
echo "  Route Tables:"
echo "  Controls WHERE traffic goes"
echo "  Each subnet has one route table"
echo "  Rules: destination → target"
echo "  10.0.0.0/16 → local (same VPC)"
echo "  0.0.0.0/0 → igw-xxx (public subnet)"
echo "  0.0.0.0/0 → nat-xxx (private subnet)"
echo ""
echo "  Security Groups:"
echo "  Virtual firewall per INSTANCE"
echo "  Stateful (return traffic auto-allowed)"
echo "  Only ALLOW rules (no deny)"
echo "  Default: deny all inbound, allow all outbound"
echo ""
echo "  Network ACLs (NACLs):"
echo "  Firewall per SUBNET"
echo "  Stateless (must allow both directions)"
echo "  Both ALLOW and DENY rules"
echo "  Numbered rules, processed in order"
echo "  Default: allow all in and out"

echo ""
echo "============================================"
echo "   ARCHITECTURE REFERENCE COMPLETE"
echo "============================================"
