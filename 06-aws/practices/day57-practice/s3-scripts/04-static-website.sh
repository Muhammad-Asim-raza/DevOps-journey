#!/bin/bash
# ================================================
# 04-static-website.sh
# S3 Static Website Hosting
# Author: Asim Raza - Day 57
# ================================================

source ../s3-configs/bucket-config.sh 2>/dev/null || \
    BUCKET_NAME="devops-journey-demo-day57"

echo "============================================"
echo "   S3 STATIC WEBSITE HOSTING"
echo "   Author: Asim Raza - Day 57"
echo "============================================"

echo ""
echo "[ WHAT IS S3 STATIC WEBSITE HOSTING? ]"
echo ""
echo "  Host HTML/CSS/JS files on S3"
echo "  S3 serves them as a website"
echo "  No web server needed (no EC2, no nginx)"
echo "  Infinitely scalable"
echo "  Cost: cents per month for most sites"
echo ""
echo "  Limitations:"
echo "  ONLY static files (no server-side code)"
echo "  No PHP, Python, Node.js execution"
echo "  Use CloudFront in front for:"
echo "  - HTTPS (S3 website endpoint is HTTP only)"
echo "  - Custom domain"
echo "  - Performance (edge caching)"
echo "  - DDoS protection"

echo ""
echo "[ STEP 1: Enable static website hosting ]"

# Need public access for website
echo "aws s3api delete-public-access-block \
    --bucket \"$BUCKET_NAME\"" \
    2>/dev/null || true

echo "aws s3api put-bucket-website \
    --bucket \"$BUCKET_NAME\" \
    --website-configuration '{
        \"IndexDocument\": {\"Suffix\": \"index.html\"},
        \"ErrorDocument\": {\"Key\": \"error.html\"}
    }'" \
    2>/dev/null && \
    echo "  ✅ Static website hosting enabled" || \
    echo "  (Would enable website hosting)"

echo ""
echo "[ STEP 2: Bucket policy for public read ]"
cat > /tmp/website-policy.json << POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${BUCKET_NAME}/*"
        }
    ]
}
POLICY

echo "aws s3api put-bucket-policy \
    --bucket \"$BUCKET_NAME\" \
    --policy file:///tmp/website-policy.json" \
    2>/dev/null && \
    echo "  ✅ Public read policy applied" || \
    echo "  (Would apply public read policy)"

echo ""
echo "[ STEP 3: Upload website files ]"

echo "aws s3 cp ../website-demo/index.html \
    \"s3://${BUCKET_NAME}/index.html\" \
    --content-type \"text/html\"" \
    2>/dev/null && \
    echo "  ✅ index.html uploaded" || \
    echo "  aws s3 cp index.html s3://BUCKET/"

echo "aws s3 cp ../website-demo/error.html \
    \"s3://${BUCKET_NAME}/error.html\" \
    --content-type \"text/html\"" \
    2>/dev/null && \
    echo "  ✅ error.html uploaded" || \
    echo "  aws s3 cp error.html s3://BUCKET/"

echo ""
echo "[ WEBSITE ENDPOINTS ]"
echo ""
REGION_FOR_URL="${REGION:-us-east-1}"

if [ "$REGION_FOR_URL" = "us-east-1" ]; then
    echo "  HTTP (S3 website endpoint):"
    echo "  http://${BUCKET_NAME}.s3-website-us-east-1.amazonaws.com"
else
    echo "  HTTP (S3 website endpoint):"
    echo "  http://${BUCKET_NAME}.s3-website.${REGION_FOR_URL}.amazonaws.com"
fi

echo ""
echo "  REST endpoint (not website):"
echo "  https://${BUCKET_NAME}.s3.amazonaws.com/index.html"
echo "  (Different! REST = downloads, website = browser)"

echo ""
echo "[ PRODUCTION PATTERN: S3 + CloudFront ]"
echo ""
echo "  S3 static website (HTTP only) ← not ideal"
echo "  S3 + CloudFront (HTTPS + custom domain) ← production"
echo ""
echo "  Benefits of CloudFront in front:"
echo "  ✅ HTTPS with SSL certificate (free via ACM)"
echo "  ✅ Custom domain (www.mysite.com)"
echo "  ✅ Edge caching (faster worldwide)"
echo "  ✅ DDoS protection (AWS Shield Standard)"
echo "  ✅ Geo restrictions"
echo "  ✅ Access logs"
echo ""
echo "  Setup:"
echo "  1. S3 bucket: PRIVATE (not website mode)"
echo "  2. CloudFront: Origin = S3 bucket"
echo "  3. OAC: CloudFront → S3 bucket policy"
echo "  4. ACM: free SSL cert for your domain"
echo "  5. Route53: CNAME to CloudFront URL"

echo ""
echo "[ SYNC FOR DEPLOYMENTS ]"
echo ""
echo "  Deploy React/Vue/Next.js build:"
echo "  npm run build"
echo "  aws s3 sync ./build/ s3://my-website/ \\"
echo "    --delete \\"
echo "    --cache-control 'max-age=31536000' \\"
echo "    --exclude 'index.html'"
echo ""
echo "  # Upload index.html separately (no long cache)"
echo "  aws s3 cp ./build/index.html s3://my-website/ \\"
echo "    --cache-control 'no-cache, no-store'"
echo ""
echo "  # Invalidate CloudFront cache:"
echo "  aws cloudfront create-invalidation \\"
echo "    --distribution-id DIST_ID \\"
echo "    --paths '/*'"
echo ""
echo "  Why different cache for index.html?"
echo "  Assets: long cache (hash in filename = changes on deploy)"
echo "  index.html: no cache (must reload to get new asset hashes)"

echo ""
echo "============================================"
echo "   STATIC WEBSITE COMPLETE"
echo "============================================"
