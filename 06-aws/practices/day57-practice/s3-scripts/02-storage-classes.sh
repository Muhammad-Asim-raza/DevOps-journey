#!/bin/bash
# ================================================
# 02-storage-classes.sh
# S3 Storage Classes and Cost Optimization
# Author: Asim Raza - Day 57
# ================================================

echo "============================================"
echo "   S3 STORAGE CLASSES"
echo "   Match class to access pattern = save money"
echo "============================================"

echo ""
echo "[ STORAGE CLASS COMPARISON ]"
echo ""
printf "%-28s %-12s %-12s %-20s\n" \
    "Class" "Cost/GB/mo" "Retrieval" "Use Case"
printf "%-28s %-12s %-12s %-20s\n" \
    "-----" "----------" "---------" "--------"
printf "%-28s %-12s %-12s %-20s\n" \
    "STANDARD" "\$0.023" "Immediate" "Frequent access"
printf "%-28s %-12s %-12s %-20s\n" \
    "INTELLIGENT_TIERING" "\$0.023+" "Immediate" "Unknown pattern"
printf "%-28s %-12s %-12s %-20s\n" \
    "STANDARD_IA" "\$0.0125" "Immediate" "Monthly access"
printf "%-28s %-12s %-12s %-20s\n" \
    "ONEZONE_IA" "\$0.01" "Immediate" "Recreatable data"
printf "%-28s %-12s %-12s %-20s\n" \
    "GLACIER_IR" "\$0.004" "Immediate" "Archive+fast"
printf "%-28s %-12s %-12s %-20s\n" \
    "GLACIER" "\$0.0036" "1-5 hours" "Archival"
printf "%-28s %-12s %-12s %-20s\n" \
    "GLACIER_DEEP_ARCHIVE" "\$0.00099" "12-48 hours" "7+ year archive"

echo ""
echo "[ DETAILED EXPLANATION ]"
echo ""
echo "  S3 STANDARD:"
echo "  - 3+ AZs redundancy (highest durability)"
echo "  - Immediate access"
echo "  - No minimum storage duration"
echo "  - Use: active content, frequently accessed data"
echo "  - Cost: $0.023/GB/month"
echo ""
echo "  S3 INTELLIGENT-TIERING:"
echo "  - Automatically moves objects between tiers"
echo "  - Frequent, Infrequent, Archive tiers"
echo "  - Small monitoring fee per object"
echo "  - Use: unknown or changing access patterns"
echo "  - Great for: mixed workloads you can't predict"
echo ""
echo "  S3 STANDARD-IA (Infrequent Access):"
echo "  - Same durability as Standard (3+ AZs)"
echo "  - Retrieval fee per GB"
echo "  - Minimum 30-day storage charge"
echo "  - Use: backups accessed monthly"
echo "  - Cost: $0.0125/GB/month storage + retrieval"
echo ""
echo "  S3 ONE ZONE-IA:"
echo "  - 1 AZ only (20% cheaper than Standard-IA)"
echo "  - If AZ goes down: data UNAVAILABLE"
echo "  - Use: ONLY for recreatable data"
echo "  - Example: thumbnail images (regeneratable)"
echo "  - Never for: primary backups, critical data"
echo ""
echo "  S3 GLACIER INSTANT RETRIEVAL:"
echo "  - Same speed as Standard"
echo "  - Minimum 90-day storage"
echo "  - Use: quarterly accessed archives"
echo ""
echo "  S3 GLACIER FLEXIBLE RETRIEVAL:"
echo "  - 1-5 hours retrieval (Expedited: minutes for \$)"
echo "  - Minimum 90-day storage"
echo "  - Use: backups, disaster recovery archives"
echo ""
echo "  S3 GLACIER DEEP ARCHIVE:"
echo "  - Cheapest option (\$0.00099/GB/month)"
echo "  - 12-48 hours retrieval"
echo "  - Minimum 180-day storage"
echo "  - Use: compliance data, 7+ year retention"
echo "  - Example: medical records, financial records"

echo ""
echo "[ S3 LIFECYCLE POLICIES ]"
echo ""
echo "  Automatically transition objects between classes"
echo "  Based on: age of object"
echo ""
echo "  Example lifecycle for backup files:"
echo "  Day 0:   Upload → STANDARD"
echo "  Day 30:  Transition → STANDARD_IA (saves 46%)"
echo "  Day 90:  Transition → GLACIER"
echo "  Day 365: Transition → GLACIER_DEEP_ARCHIVE"
echo "  Day 2555 (7yr): Expire (delete permanently)"

# Create lifecycle policy
cat > ../s3-configs/lifecycle-policy.json << 'EOF'
{
  "Rules": [
    {
      "ID": "DevOpsArtifactLifecycle",
      "Status": "Enabled",
      "Filter": {
        "Prefix": "artifacts/"
      },
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "STANDARD_IA"
        },
        {
          "Days": 90,
          "StorageClass": "GLACIER"
        },
        {
          "Days": 365,
          "StorageClass": "DEEP_ARCHIVE"
        }
      ],
      "Expiration": {
        "Days": 2555
      }
    },
    {
      "ID": "CleanupIncompleteMultipartUploads",
      "Status": "Enabled",
      "Filter": {},
      "AbortIncompleteMultipartUpload": {
        "DaysAfterInitiation": 7
      }
    },
    {
      "ID": "CleanupOldVersions",
      "Status": "Enabled",
      "Filter": {
        "Prefix": ""
      },
      "NoncurrentVersionTransitions": [
        {
          "NoncurrentDays": 30,
          "StorageClass": "STANDARD_IA"
        },
        {
          "NoncurrentDays": 90,
          "StorageClass": "GLACIER"
        }
      ],
      "NoncurrentVersionExpiration": {
        "NoncurrentDays": 365
      }
    }
  ]
}
EOF

echo "  Lifecycle policy saved: s3-configs/lifecycle-policy.json"
echo ""

# Apply lifecycle policy if bucket exists
source ../s3-configs/bucket-config.sh 2>/dev/null || \
    BUCKET_NAME="devops-journey-demo-day57"

echo "  Applying lifecycle policy..."
echo "aws s3api put-bucket-lifecycle-configuration \\"
echo "    --bucket \"$BUCKET_NAME\" \\"
echo "    --lifecycle-configuration \\"
echo "        file://../s3-configs/lifecycle-policy.json"
echo "  aws s3api put-bucket-lifecycle-configuration \\"
echo "    --bucket BUCKET --lifecycle-configuration file://lifecycle.json"

echo ""
echo "[ COST SAVINGS EXAMPLE ]"
echo ""
echo "  100GB of CI/CD artifacts:"
echo "  Without lifecycle:  100GB × \$0.023 = \$2.30/month"
echo "  With lifecycle:"
echo "    0-30 days:   100GB × \$0.023  = \$2.30"
echo "    30-90 days:  100GB × \$0.0125 = \$1.25 (IA)"
echo "    90-365 days: 100GB × \$0.0036 = \$0.36 (Glacier)"
echo "    365+ days:   100GB × \$0.00099= \$0.10 (Deep)"
echo "  Savings: up to 96% on old data"

echo ""
echo "============================================"
echo "   STORAGE CLASSES COMPLETE"
echo "============================================"
