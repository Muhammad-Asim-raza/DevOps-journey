#!/bin/bash
# ================================================
# s3-reference.sh
# S3 Complete Reference
# Author: Asim Raza - Day 57
# ================================================

echo "============================================"
echo "   AWS S3 COMPLETE REFERENCE"
echo "   Author: Asim Raza - Day 57"
echo "============================================"

echo ""
echo "[ CORE CONCEPTS ]"
echo "  Bucket: globally unique container"
echo "  Object: file = key + value + metadata"
echo "  Key:    'path' (not real folder, just naming)"
echo "  URL:    https://BUCKET.s3.REGION.amazonaws.com/KEY"

echo ""
echo "[ BUCKET SETUP CHECKLIST ]"
echo "  ✅ aws s3api create-bucket"
echo "  ✅ put-public-access-block (block all)"
echo "  ✅ put-bucket-versioning (enable)"
echo "  ✅ put-bucket-encryption (AES256)"
echo "  ✅ put-bucket-policy (HTTPS only)"
echo "  ✅ put-bucket-lifecycle-configuration"

echo ""
echo "[ OBJECT OPERATIONS ]"
echo "  aws s3 cp FILE s3://BUCKET/KEY        upload"
echo "  aws s3 cp s3://BUCKET/KEY FILE        download"
echo "  aws s3 sync ./DIR/ s3://BUCKET/       sync dir"
echo "  aws s3 ls s3://BUCKET/ --recursive    list all"
echo "  aws s3 rm s3://BUCKET/KEY             delete"
echo "  aws s3 presign s3://BUCKET/KEY --expires-in 3600"

echo ""
echo "[ STORAGE CLASSES ]"
echo "  STANDARD:       \$0.023  active data"
echo "  STANDARD_IA:    \$0.0125 backups (monthly access)"
echo "  GLACIER:        \$0.0036 archive (hours retrieval)"
echo "  GLACIER_DEEP:   \$0.00099 compliance (12-48hr)"

echo ""
echo "[ SECURITY POLICIES ]"
echo "  HTTPS-only:  Deny if SecureTransport=false"
echo "  Encryption:  Deny PutObject without SSE header"
echo "  Public site: Allow GetObject to Principal *"
echo "  CloudFront:  Allow cloudfront.amazonaws.com"

echo ""
echo "[ DEVOPS PATTERNS ]"
echo "  Terraform state: backend 's3' + DynamoDB lock"
echo "  CI/CD artifacts: immutable SHA in key path"
echo "  Static website: sync build + CloudFront"
echo "  App uploads: presigned PUT URL to frontend"
echo "  Events: S3 → Lambda (on ObjectCreated)"
echo "  Replication: CRR (DR) or SRR (compliance)"

echo ""
echo "[ GOTCHAS ]"
echo "  us-east-1 create-bucket: NO LocationConstraint"
echo "  Other regions: NEED --create-bucket-configuration"
echo "  Versioning on: rm creates delete marker (not permanent)"
echo "  Bucket names: globally unique (across all AWS)"
echo "  Data IN: free  |  Data OUT: \$0.09/GB"

echo ""
echo "============================================"
echo "   S3 REFERENCE COMPLETE"
echo "============================================"
