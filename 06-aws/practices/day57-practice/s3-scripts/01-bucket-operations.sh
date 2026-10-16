#!/bin/bash
# ================================================
# 01-bucket-operations.sh
# S3 Bucket and Object Operations
# Author: Asim Raza - Day 57
# PRINT ONLY — NO AWS COMMANDS EXECUTE
# ================================================
set -euo pipefail

REGION="${AWS_DEFAULT_REGION:-us-east-1}"

# Print AWS identity command instead of executing it
echo 'aws sts get-caller-identity --query Account --output text'
ACCOUNT_ID="123456789012"

# Bucket names must be globally unique!
BUCKET_NAME="devops-journey-${ACCOUNT_ID}-day57"

echo "============================================"
echo "   S3 BUCKET OPERATIONS"
echo "   Author: Asim Raza - Day 57"
echo "============================================"
echo ""
echo "Account: $ACCOUNT_ID"
echo "Bucket:  $BUCKET_NAME"
echo "Region:  $REGION"

# ── CREATE BUCKET ────────────────────────────────
echo ""
echo "[ STEP 1: Create Bucket ]"
echo ""
echo "  Bucket names:"
echo "  - 3-63 characters"
echo "  - lowercase letters, numbers, hyphens only"
echo "  - NO underscores (use hyphens)"
echo "  - globally unique across ALL AWS"
echo "  - cannot start/end with hyphen"
echo "  - cannot be formatted as IP (192.168.1.1)"
echo ""

# us-east-1 does NOT use LocationConstraint!
# All OTHER regions DO need it

if [ "$REGION" = "us-east-1" ]; then
    echo "aws s3api create-bucket \
        --bucket $BUCKET_NAME \
        --region $REGION"
else
    echo "aws s3api create-bucket \
        --bucket $BUCKET_NAME \
        --region $REGION \
        --create-bucket-configuration \
        LocationConstraint=$REGION"
fi

echo "  (Would create bucket: $BUCKET_NAME)"

# ── BLOCK PUBLIC ACCESS ──────────────────────────
echo ""
echo "[ STEP 2: Block All Public Access (Security!) ]"
echo ""
echo "  By default since 2023, S3 blocks all public access"
echo "  But ALWAYS explicitly set it to be sure:"
echo ""

echo "aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo "  (Would block all public access)"

echo ""
echo "  The 4 settings explained:"
echo "  BlockPublicAcls:       block ACLs that make bucket public"
echo "  IgnorePublicAcls:      ignore any existing public ACLs"
echo "  BlockPublicPolicy:     block bucket policies allowing public"
echo "  RestrictPublicBuckets: restrict access to bucket via policy"

# ── ENABLE VERSIONING ────────────────────────────
echo ""
echo "[ STEP 3: Enable Versioning ]"
echo ""
echo "  Versioning keeps ALL versions of every object"
echo "  Delete an object? Its previous version is safe"
echo "  Overwrite a file? Old version preserved"
echo "  Use for: important files, disaster recovery"
echo ""

echo "aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled"

echo "  (Would enable versioning)"

# ── ENABLE ENCRYPTION ────────────────────────────
echo ""
echo "[ STEP 4: Enable Default Encryption ]"
echo ""
echo "  Encrypt ALL objects by default (at rest)"
echo "  SSE-S3:  AWS manages keys (free)"
echo "  SSE-KMS: You manage keys via KMS (adds cost)"
echo "  DSSE-KMS: Dual-layer KMS (compliance)"
echo ""

echo "aws s3api put-bucket-encryption \
    --bucket $BUCKET_NAME \
    --server-side-encryption-configuration '{
        \"Rules\": [{
            \"ApplyServerSideEncryptionByDefault\": {
                \"SSEAlgorithm\": \"AES256\"
            },
            \"BucketKeyEnabled\": true
        }]
    }'"

echo "  (Would enable SSE-S3 encryption)"

# ── UPLOAD OBJECTS ───────────────────────────────
echo ""
echo "[ STEP 5: Upload Objects ]"
echo ""

# Create test files
echo "DevOps Journey S3 Demo - Day 57" > /tmp/readme.txt
echo '{"service": "s3-demo", "day": 57}' > /tmp/config.json
echo "deploy: v1.0.57" > /tmp/deployment.yaml

# Upload with AWS CLI
echo "  # Single file upload:"

echo "aws s3 cp /tmp/readme.txt \
    s3://${BUCKET_NAME}/docs/readme.txt"

echo "  (Would upload: docs/readme.txt)"

echo ""
echo "  # Upload with metadata and storage class:"

echo "aws s3 cp /tmp/config.json \
    s3://${BUCKET_NAME}/configs/config.json \
    --metadata author=asim-raza,day=57 \
    --storage-class STANDARD"

echo "  (Would upload: configs/config.json)"

echo ""
echo "  # Upload deployment artifact:"

echo "aws s3 cp /tmp/deployment.yaml \
    s3://${BUCKET_NAME}/artifacts/v1.0.57/deployment.yaml"

echo "  (Would upload: artifacts/v1.0.57/deployment.yaml)"

echo ""
echo "  # Sync entire directory to S3:"
echo "  aws s3 sync ./dist/ s3://${BUCKET_NAME}/website/ \\"
echo "    --delete \\"
echo "    --exclude '*.tmp'"
echo "  --delete: removes objects in S3 not in local dir"
echo "  (great for static website deployment!)"

# ── LIST AND DOWNLOAD ────────────────────────────
echo ""
echo "[ STEP 6: List and Download ]"
echo ""

echo "  # List bucket:"
echo "aws s3 ls s3://${BUCKET_NAME}/"
echo ""

echo "  # List recursively:"
echo "aws s3 ls s3://${BUCKET_NAME}/ \
    --recursive \
    --human-readable"

echo ""
echo "  # Download single file:"
echo "  aws s3 cp s3://${BUCKET_NAME}/docs/readme.txt ."
echo ""
echo "  # Download all objects from prefix:"
echo "  aws s3 sync s3://${BUCKET_NAME}/artifacts/ ./artifacts/"
echo ""
echo "  # Download specific version:"
echo "  aws s3api get-object \\"
echo "    --bucket $BUCKET_NAME \\"
echo "    --key docs/readme.txt \\"
echo "    --version-id VERSION_ID \\"
echo "    readme-old.txt"

# ── DELETE OBJECTS ───────────────────────────────
echo ""
echo "[ OBJECT DELETION WITH VERSIONING ]"
echo ""
echo "  # With versioning ON:"
echo "  aws s3 rm s3://BUCKET/key"
echo "  → Creates a 'delete marker' (soft delete)"
echo "  → Object still exists (previous versions)"
echo "  → Object appears deleted to GET requests"
echo ""
echo "  # Permanently delete specific version:"
echo "  aws s3api delete-object \\"
echo "    --bucket BUCKET \\"
echo "    --key docs/file.txt \\"
echo "    --version-id VERSION_ID"
echo ""
echo "  # Delete all versions (empty versioned bucket):"
echo "  aws s3api list-object-versions \\"
echo "    --bucket BUCKET \\"
echo "    --query 'Versions[*].[Key,VersionId]' \\"
echo "    --output text | while read key vid; do"
echo "    aws s3api delete-object \\"
echo "      --bucket BUCKET --key \"\$key\" --version-id \"\$vid\""
echo "  done"

echo ""
echo "[ BUCKET OPERATIONS ]"
echo ""
echo "  # List all your buckets:"
echo "  aws s3 ls"
echo "  aws s3api list-buckets"
echo ""
echo "  # Get bucket info:"
echo "  aws s3api get-bucket-location --bucket BUCKET"
echo "  aws s3api get-bucket-versioning --bucket BUCKET"
echo "  aws s3api get-bucket-encryption --bucket BUCKET"
echo ""
echo "  # Delete EMPTY bucket:"
echo "  aws s3 rb s3://BUCKET"
echo ""
echo "  # Delete bucket and ALL contents:"
echo "  aws s3 rb s3://BUCKET --force"
echo "  ⚠️  PERMANENT - cannot undo!"

echo ""
echo "============================================"
echo "   BUCKET OPERATIONS COMPLETE"
echo "   Bucket: $BUCKET_NAME"
echo "============================================"

# Save bucket name for other scripts
echo "BUCKET_NAME=$BUCKET_NAME" > \
    ../s3-configs/bucket-config.sh
echo "REGION=$REGION" >> \
    ../s3-configs/bucket-config.sh
