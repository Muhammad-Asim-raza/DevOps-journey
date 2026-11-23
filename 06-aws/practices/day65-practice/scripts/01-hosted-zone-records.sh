#!/bin/bash
# ================================================
# 01-hosted-zone-records.sh
# Create a hosted zone and manage records
# Author: Asim Raza - Day 65
# ================================================
DOMAIN="${DOMAIN:-yourdomain.example}"   # replace with a domain you own

echo "============================================"
echo "   ROUTE 53: HOSTED ZONES AND RECORDS"
echo "============================================"

echo ""
echo "[ STEP 1: Create a public hosted zone ]"
echo "aws route53 create-hosted-zone --name \"$DOMAIN\" --caller-reference \"day65-$(date +%s)\" --query 'HostedZone.Id' --output text"

echo ""
echo "[ STEP 2: Delegate: copy the 4 NS records to your registrar ]"
echo "  aws route53 get-hosted-zone --id ZONE_ID \\"
echo "    --query 'DelegationSet.NameServers'"
echo "  If you bought the domain elsewhere, set THESE 4 name servers"
echo "  at the registrar. Until then, Route 53 is never asked."
echo "  Domains registered in Route 53 point at the matching zone,"
echo "  but verify it if you ever recreate a zone (new zone = new NS set!)."

echo ""
echo "[ STEP 3: Create/Update records with a change batch ]"
cat > ../configs/records.json << EOF
{
  "Comment": "Day 65 records",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "www.${DOMAIN}",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [{"Value": "203.0.113.10"}]
      }
    },
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "${DOMAIN}",
        "Type": "TXT",
        "TTL": 300,
        "ResourceRecords": [{"Value": "\\"v=spf1 -all\\""}]
      }
    }
  ]
}
EOF
echo "  UPSERT = create if missing, update if present (idempotent)."
echo "  Other actions: CREATE (fails if exists), DELETE (must match exactly)"
echo "  203.0.113.10 is a documentation-only IP (RFC 5737) for demos."
echo ""
echo "  aws route53 change-resource-record-sets \\"
echo "    --hosted-zone-id ZONE_ID \\"
echo "    --change-batch file://../configs/records.json"

echo ""
echo "[ STEP 4: Verify ]"
echo "  aws route53 list-resource-record-sets --hosted-zone-id ZONE_ID"
echo "  dig www.$DOMAIN                    # via your resolver"
echo "  dig @ns-123.awsdns-45.com www.$DOMAIN   # ask Route 53 directly"
echo "  dig +short NS $DOMAIN             # confirm delegation"
echo "  nslookup www.$DOMAIN"
echo "  (Day 12-14 DNS tools: dig is your friend)"

echo ""
echo "[ TTL STRATEGY ]"
echo "  Normal operation: 300 s (5 min) to 3600 s"
echo "  BEFORE a planned migration: lower TTL to 60 s a day ahead,"
echo "  so cutover propagates fast; raise it again afterwards."
echo "  Alias records to AWS resources use the target's TTL (no TTL field)."
echo "  Low TTL = faster change, more queries (small cost)."

echo ""
echo "[ COSTS ]"
echo "  Hosted zone ~\$0.50/month (a zone deleted within 12 hours is free)"
echo "  Standard queries ~\$0.40 per million; alias queries to AWS free"
echo "  Health checks ~\$0.50-\$2/month each depending on type"
echo "  Domain registration: yearly, varies by TLD"
echo ""
echo "[ CLEANUP ]"
echo "  Delete all non-default records first (keep NS/SOA), then:"
echo "  aws route53 delete-hosted-zone --id ZONE_ID"
echo "============================================"
