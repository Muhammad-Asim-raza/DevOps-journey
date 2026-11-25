#!/bin/bash
# ================================================
# 03-custom-domain.sh
# Custom domain for the Day 63 HTTP API
# Author: Asim Raza - Day 65
# ================================================

echo 'source ../../day63-practice/configs/api-config.sh 2>/dev/null || {'
echo '    API_ID="abc123demo"; REGION="us-east-1"; }'
echo 'DOMAIN="${DOMAIN:-yourdomain.example}"'
echo 'API_DOMAIN="api.${DOMAIN}"'
echo 'ZONE_ID="${ZONE_ID:-Z0DEMO12345}"'

echo ""
echo "============================================"
echo "   CUSTOM DOMAIN FOR API GATEWAY"
echo "============================================"

echo ""
echo "[ STEP 1: Request ACM certificate ]"
echo 'CERT_ARN=$(aws acm request-certificate --domain-name "$API_DOMAIN" \'
echo '    --validation-method DNS --region "$REGION" \'
echo '    --query CertificateArn --output text 2>/dev/null) || \'
echo '    CERT_ARN="arn:aws:acm:${REGION}:123456789012:certificate/demo"'
echo 'echo "$CERT_ARN"'

echo ""
echo "[ STEP 2: DNS validation ]"
echo 'aws acm describe-certificate --certificate-arn $CERT_ARN \'
echo '    --query "Certificate.DomainValidationOptions[0].ResourceRecord"'
echo "Create that CNAME in the hosted zone. Wait for ISSUED:"
echo 'aws acm wait certificate-validated --certificate-arn $CERT_ARN'
echo "Keep the validation CNAME in place so ACM can auto-renew."

echo ""
echo "[ STEP 3: API Gateway custom domain + mapping ]"
echo 'aws apigatewayv2 create-domain-name \'
echo '    --domain-name $API_DOMAIN \'
echo '    --domain-name-configurations CertificateArn=$CERT_ARN,EndpointType=REGIONAL'

echo ""
echo 'aws apigatewayv2 create-api-mapping \'
echo '    --domain-name $API_DOMAIN --api-id $API_ID --stage prod'
echo '(mapping to a stage named $default removes the /prod path part)'

echo ""
echo "[ STEP 4: ALIAS record to the API Gateway domain ]"
echo "Look up the target:"
echo 'aws apigatewayv2 get-domain-name --domain-name $API_DOMAIN \'
echo '    --query "DomainNameConfigurations[0].[ApiGatewayDomainName,HostedZoneId]"'

echo 'cat << '\''EOF'\'''
echo '  {'
echo '    "Changes": [{'
echo '      "Action": "UPSERT",'
echo '      "ResourceRecordSet": {'
echo '        "Name": "api.yourdomain.example",'
echo '        "Type": "A",'
echo '        "AliasTarget": {'
echo '          "HostedZoneId": "<HostedZoneId returned above>",'
echo '          "DNSName": "<ApiGatewayDomainName returned above>",'
echo '          "EvaluateTargetHealth": false'
echo '        }'
echo '      }'
echo '    }]'
echo '  }'
echo 'EOF'

echo "The AliasTarget HostedZoneId is the TARGET service's zone,"
echo "NOT your own zone ID. A frequent mix-up."

echo ""
echo "[ TEST ]"
echo 'curl -i https://${API_DOMAIN}/health'
echo 'dig +short ${API_DOMAIN}'
echo "============================================"
