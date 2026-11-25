#!/bin/bash
# ================================================
# 04-private-zone.sh
# Private hosted zone for internal service names
# Author: Asim Raza - Day 65
# ================================================

echo 'REGION="${AWS_DEFAULT_REGION:-us-east-1}"'
echo 'VPC_ID="${VPC_ID:-vpc-0demo12345}"'

echo "============================================"
echo "   PRIVATE HOSTED ZONE"
echo "============================================"
echo ""

echo 'aws route53 create-hosted-zone --name corp.internal \'
echo '    --caller-reference "priv-$(date +%s)" \'
echo '    --vpc VPCRegion=$REGION,VPCId=$VPC_ID \'
echo '    --hosted-zone-config Comment=internal,PrivateZone=true \'
echo '    --query "HostedZone.Id" --output text 2>/dev/null || \'
echo '    echo "(would create; set VPC_ID to a real VPC)"'

echo ""
echo "Then a CNAME for your database (CNAME is fine: not the apex):"
echo "  db.corp.internal  CNAME  devops-journey-postgres.xxxx.us-east-1.rds.amazonaws.com"
echo ""

echo "Test FROM an instance inside the VPC:"
echo "  dig +short db.corp.internal"
echo "From your laptop it will NOT resolve (that's the point)."
echo ""

echo "Associate more VPCs:"
echo 'aws route53 associate-vpc-with-hosted-zone --hosted-zone-id Z... \'
echo '    --vpc VPCRegion=$REGION,VPCId=vpc-other'

echo ""
echo "Split-horizon DNS: same name (api.example.com) in a public AND"
echo "a private zone; inside the VPC the private answer wins,"
echo "outside the public one is returned."
echo ""

echo "VPC DNS resolver lives at base-of-VPC-CIDR + 2"
echo "(10.0.0.2 for 10.0.0.0/16; also 169.254.169.253)."
echo "Hybrid/on-prem: Route 53 Resolver inbound/outbound endpoints."
echo "============================================"
