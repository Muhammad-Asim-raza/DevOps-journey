#!/bin/bash
# ================================================
# subnet-calculator.sh
# Subnet Calculator Without External Tools
# Author: Asim Raza
# Day 15 of DevOps Journey
# ================================================

calculate_subnet() {
    local CIDR=$1
    local IP=$(echo $CIDR | cut -d'/' -f1)
    local PREFIX=$(echo $CIDR | cut -d'/' -f2)

    # Split IP into octets
    local O1=$(echo $IP | cut -d'.' -f1)
    local O2=$(echo $IP | cut -d'.' -f2)
    local O3=$(echo $IP | cut -d'.' -f3)
    local O4=$(echo $IP | cut -d'.' -f4)

    # Calculate host bits and addresses
    local HOST_BITS=$((32 - PREFIX))
    local TOTAL_ADDRESSES=$((2 ** HOST_BITS))
    local USABLE_HOSTS=$((TOTAL_ADDRESSES - 2))

    # Calculate subnet mask
    local MASK_BITS=$((0xFFFFFFFF << HOST_BITS & 0xFFFFFFFF))
    local M1=$(( (MASK_BITS >> 24) & 255 ))
    local M2=$(( (MASK_BITS >> 16) & 255 ))
    local M3=$(( (MASK_BITS >> 8) & 255 ))
    local M4=$(( MASK_BITS & 255 ))

    # Network address (zero out host bits)
    local N4=$((O4 & M4))
    local N3=$((O3 & M3))
    local N2=$((O2 & M2))
    local N1=$((O1 & M1))

    # Broadcast address (set all host bits to 1)
    local B4=$(( N4 | (255 - M4) ))
    local B3=$(( N3 | (255 - M3) ))
    local B2=$(( N2 | (255 - M2) ))
    local B1=$(( N1 | (255 - M1) ))

    # First usable host
    local F4=$((N4 + 1))

    # Last usable host
    local L4=$((B4 - 1))

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "SUBNET CALCULATION: $CIDR"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Network Address   : $N1.$N2.$N3.$N4"
    echo "Subnet Mask       : $M1.$M2.$M3.$M4"
    echo "Broadcast Address : $B1.$B2.$B3.$B4"
    echo "First Usable IP   : $N1.$N2.$N3.$F4"
    echo "Last Usable IP    : $B1.$B2.$B3.$L4"
    echo "Total Addresses   : $TOTAL_ADDRESSES"
    echo "Usable Hosts      : $USABLE_HOSTS"
    echo "Prefix Length     : /$PREFIX"
    echo "Host Bits         : $HOST_BITS"
    echo ""
}

echo "============================================"
echo "   SUBNET CALCULATOR"
echo "   Author: Asim Raza - Day 15"
echo "============================================"
echo ""

# Calculate common subnets
calculate_subnet "192.168.1.0/24"
calculate_subnet "10.0.0.0/16"
calculate_subnet "10.0.1.0/24"
calculate_subnet "172.16.0.0/12"
calculate_subnet "10.0.0.0/8"

echo "============================================"
echo "   CIDR REFERENCE TABLE"
echo "============================================"
echo ""
echo "Prefix  Addresses  Usable Hosts  Subnet Mask"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for PREFIX in 32 30 28 27 26 25 24 23 22 20 18 16; do
    HOST_BITS=$((32 - PREFIX))
    TOTAL=$((2 ** HOST_BITS))
    USABLE=$((TOTAL - 2))
    if [ $PREFIX -ge 24 ]; then
        MASK="255.255.255.$((256 - TOTAL))"
    elif [ $PREFIX -eq 23 ]; then
        MASK="255.255.254.0"
    elif [ $PREFIX -eq 22 ]; then
        MASK="255.255.252.0"
    elif [ $PREFIX -eq 20 ]; then
        MASK="255.255.240.0"
    elif [ $PREFIX -eq 18 ]; then
        MASK="255.255.192.0"
    elif [ $PREFIX -eq 16 ]; then
        MASK="255.255.0.0"
    else
        MASK="varies"
    fi
    printf "  /%-4s  %-12s %-14s %s\n" \
        "$PREFIX" "$TOTAL" "$USABLE" "$MASK"
done

echo ""
echo "============================================"
echo "   VPC DESIGN EXAMPLE"
echo "============================================"
echo ""
echo "VPC: 10.0.0.0/16 (65,534 usable IPs)"
echo ""
echo "Subnet Layout:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Public  Subnet AZ-A: 10.0.1.0/24  (254 hosts)"
echo "Public  Subnet AZ-B: 10.0.2.0/24  (254 hosts)"
echo "Private Subnet AZ-A: 10.0.10.0/24 (254 hosts)"
echo "Private Subnet AZ-B: 10.0.11.0/24 (254 hosts)"
echo "DB      Subnet AZ-A: 10.0.20.0/26 (62 hosts)"
echo "DB      Subnet AZ-B: 10.0.21.0/26 (62 hosts)"
echo ""
echo "Traffic Rules:"
echo "Public subnets  → Route: 0.0.0.0/0 → IGW"
echo "Private subnets → Route: 0.0.0.0/0 → NAT GW"
echo "DB subnets      → No internet route"
echo "============================================"
