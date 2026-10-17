#!/bin/bash
# ================================================
# 03-s3-security.sh
# S3 Security - Policies, ACLs, Encryption
# Author: Asim Raza - Day 57
# ================================================

echo "============================================"
echo "   S3 SECURITY"
echo "   Multiple layers of access control"
echo "============================================"

source ../s3-configs/bucket-config.sh 2>/dev/null || \
    BUCKET_NAME="devops-journey-demo-day57"

echo ""
echo "[ S3 ACCESS CONTROL LAYERS ]"
cat << 'DIAGRAM'

  Request to S3 Object
          │
          ▼
  ┌───────────────────────────────────────┐
  │ 1. Block Public Access Settings       │
  │    (Account-level or bucket-level)    │
  │    If blocks public: DENY immediately │
  └──────────────────┬────────────────────┘
                     │
          ▼ (if not blocked)
  ┌───────────────────────────────────────┐
  │ 2. AWS Organizations SCP             │
  │    (if using Organizations)          │
  └──────────────────┬────────────────────┘
                     │
          ▼
  ┌───────────────────────────────────────┐
  │ 3. IAM Identity Policy               │
  │    (attached to user/role)           │
  │    Does identity have permission?    │
  └──────────────────┬────────────────────┘
                     │
          ▼
  ┌───────────────────────────────────────┐
  │ 4. S3 Bucket Policy                  │
  │    (resource-based policy on bucket) │
  │    Additional ALLOW or DENY?         │
  └──────────────────┬────────────────────┘
                     │
          ▼ (both must allow for cross-account)
  ┌───────────────────────────────────────┐
  │ 5. S3 ACL (legacy, avoid for new)    │
  │    Object-level ACL                  │
  └──────────────────┬────────────────────┘
                     │
                ALLOW or DENY
DIAGRAM

echo ""
echo "[ BUCKET POLICY EXAMPLES ]"
echo ""
echo "  1. Allow specific IAM role to access bucket:"
cat > ../s3-configs/role-access-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCICDRole",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:role/github-actions-role"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::devops-journey-artifacts",
        "arn:aws:s3:::devops-journey-artifacts/*"
      ]
    }
  ]
}
EOF
echo "  Saved: s3-configs/role-access-policy.json"

echo ""
echo "  2. Enforce HTTPS-only access:"
cat > ../s3-configs/https-only-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyHTTPAccess",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::MY-BUCKET",
        "arn:aws:s3:::MY-BUCKET/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
EOF
echo "  Saved: s3-configs/https-only-policy.json"
echo "  Effect: blocks ALL non-HTTPS requests"
echo "  aws:SecureTransport: false = HTTP (not HTTPS)"

echo ""
echo "  3. Allow CloudFront to access private bucket:"
cat > ../s3-configs/cloudfront-oac-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontOAC",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::MY-BUCKET/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::123456789012:distribution/DISTRIBUTION_ID"
        }
      }
    }
  ]
}
EOF
echo "  Saved: s3-configs/cloudfront-oac-policy.json"
echo "  OAC = Origin Access Control (modern)"
echo "  Bucket is private, only CloudFront can read"

echo ""
echo "  4. Enforce encryption on upload:"
cat > ../s3-configs/enforce-encryption-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyUnencryptedObjectUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::MY-BUCKET/*",
      "Condition": {
        "StringNotEqualsIfExists": {
          "s3:x-amz-server-side-encryption": [
            "aws:kms",
            "AES256"
          ]
        }
      }
    }
  ]
}
EOF
echo "  Saved: s3-configs/enforce-encryption-policy.json"
echo "  Blocks uploads without encryption header"
echo "  Ensures even accidental plaintext uploads fail"

echo ""
echo "[ APPLY BUCKET POLICY ]"
echo ""
echo "  aws s3api put-bucket-policy \\"
echo "    --bucket $BUCKET_NAME \\"
echo "    --policy file://bucket-policy.json"
echo ""

echo "aws s3api put-bucket-policy \\"
echo "    --bucket \"$BUCKET_NAME\" \\"
echo "    --policy file://../s3-configs/https-only-policy.json"
echo "  (Would apply HTTPS-only policy)"

echo ""
echo "[ ENCRYPTION OPTIONS ]"
echo ""
echo "  SSE-S3 (Server-Side Encryption with S3 keys):"
echo "  - AWS manages keys automatically"
echo "  - AES-256 encryption"
echo "  - Free"
echo "  - Default for all new buckets"
echo "  - Header: x-amz-server-side-encryption: AES256"
echo ""
echo "  SSE-KMS (Server-Side Encryption with KMS keys):"
echo "  - You manage keys in AWS KMS"
echo "  - Audit trail in CloudTrail"
echo "  - KMS cost: ~$1/key/month + API calls"
echo "  - Required for: compliance, fine-grained control"
echo "  - Header: x-amz-server-side-encryption: aws:kms"
echo ""
echo "  SSE-C (Client-Side Encryption with customer key):"
echo "  - You provide the key with each request"
echo "  - AWS encrypts/decrypts, never stores key"
echo "  - Most complex, most control"
echo "  - Use when: must own all keys"
echo ""
echo "  Client-Side Encryption:"
echo "  - You encrypt BEFORE uploading"
echo "  - AWS never sees plaintext"
echo "  - Use: highest security requirements"

echo ""
echo "[ PRE-SIGNED URLS ]"
echo ""
echo "  Share private objects temporarily"
echo "  No AWS credentials needed by recipient"
echo "  URL includes signature, expires after time"
echo ""
echo "  # Generate presigned URL (valid 1 hour):"
echo "  aws s3 presign s3://${BUCKET_NAME}/docs/readme.txt \\"
echo "    --expires-in 3600"
echo ""
echo "  # With specific expiry (7 days max for CLI):"
echo "  aws s3 presign s3://${BUCKET_NAME}/artifacts/build.zip \\"
echo "    --expires-in 604800"
echo ""
echo "  Use cases:"
echo "  - Share files with external partners"
echo "  - Allow upload without AWS creds"
echo "  - Temporary download links"
echo "  - Mobile app uploads directly to S3"

# Generate presigned URL
echo ""
if command -v aws &>/dev/null; then
    echo "aws s3 presign \\"
    echo "    \"s3://${BUCKET_NAME}/docs/readme.txt\" \\"
    echo "    --expires-in 3600"
    echo "  Generated presigned URL (expires in 1hr):"
    echo "  https://BUCKET.s3.amazonaws.com/key?X-Amz-Algorithm=......"
fi

echo ""
echo "============================================"
echo "   S3 SECURITY COMPLETE"
echo "============================================"
