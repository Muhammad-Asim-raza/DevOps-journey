# Day 57 Exercises — AWS S3
**Date:** Aug 14 2026
**Status:** ✅ Completed

---

## Exercise 1: S3 Bucket Setup ✅
- [x] Created bucket with correct naming rules
- [x] Blocked all public access
- [x] Enabled versioning
- [x] Enabled SSE-S3 default encryption
- [x] Uploaded objects with metadata

### Proof: practices/day57-practice/exercise1-proof.txt

### Naming Rules
3-63 chars, lowercase, hyphens only
Globally unique (across ALL AWS)
No underscores, no IP format
Cannot start/end with hyphen

### Setup Order (always do this)
1. create-bucket
2. put-public-access-block
3. put-bucket-versioning
4. put-bucket-encryption
5. put-bucket-policy (HTTPS only)
6. put-bucket-lifecycle-configuration

---

## Exercise 2: Storage Classes and Lifecycle ✅
- [x] All 7 storage classes compared
- [x] Lifecycle policy JSON written
- [x] Multipart upload cleanup rule added
- [x] Old version cleanup rule added

### Proof: practices/day57-practice/exercise2-proof.txt

### Lifecycle Applied
artifacts/: 30d→IA, 90d→Glacier, 365d→Deep, 2555d→Delete
Multipart cleanup: abort after 7 days
Old versions: IA→30d, Glacier→90d, expire→365d

---

## Exercise 3: S3 Security ✅
- [x] Four bucket policy examples written
- [x] HTTPS-only policy (SecureTransport)
- [x] CloudFront OAC policy
- [x] Enforce encryption policy
- [x] Presigned URL generation

### Proof: practices/day57-practice/exercise3-proof.txt

### Access Control Layers
1. Block Public Access (first line of defense)
2. SCPs (org-wide limits)
3. IAM policy (identity)
4. Bucket policy (resource)
5. ACL (legacy, avoid)

---

## Exercise 4: S3 DevOps Patterns ✅
- [x] Static website hosting configured
- [x] Terraform state backend shown
- [x] CI/CD artifact structure designed
- [x] S3 event notifications configured
- [x] Cross-region replication config written

### Proof: practices/day57-practice/exercise4-proof.txt

### Static Website Pattern
S3 only: HTTP (port 80)
S3 + CloudFront: HTTPS + custom domain + CDN
Deploy: aws s3 sync ./build/ s3://BUCKET/ --delete
index.html: Cache-Control: no-cache
assets (hashed): Cache-Control: max-age=31536000

---

## Key Files Created
- s3-configs/lifecycle-policy.json
- s3-configs/role-access-policy.json
- s3-configs/https-only-policy.json
- s3-configs/cloudfront-oac-policy.json
- s3-configs/enforce-encryption-policy.json
- s3-configs/s3-notification.json
- s3-configs/replication-config.json
- website-demo/index.html
- website-demo/error.html

---

## Summary
All 4 exercises completed Aug 14 2026

Key concepts mastered:
- S3 fundamentals (bucket/object/key)
- Globally unique bucket naming
- Block public access (always!)
- Versioning (protect from delete/overwrite)
- Default encryption (SSE-S3 free)
- All 7 storage classes
- Lifecycle policies (cost optimization)
- Bucket policies (HTTPS, OAC, encryption)
- Presigned URLs (temporary access)
- Static website hosting (+ CloudFront)
- Terraform state backend pattern
- CI/CD artifact storage
- S3 event notifications (→ Lambda)
- Cross-region replication (DR)
- S3 Select (SQL on objects)
- Cost optimization with lifecycle
