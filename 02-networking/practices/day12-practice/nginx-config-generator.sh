#!/bin/bash
# ================================================
# nginx-config-generator.sh
# Generate nginx configurations for common scenarios
# Author: Asim Raza
# Day 12 of DevOps Journey
# ================================================

echo "============================================"
echo "   NGINX CONFIG GENERATOR"
echo "============================================"

OUTPUT_DIR="./nginx-configs"
mkdir -p $OUTPUT_DIR

echo ""
echo "[ GENERATING STATIC SITE CONFIG ]"
cat > $OUTPUT_DIR/static-site.conf << 'EOF'
server {
    listen 80;
    server_name example.com www.example.com;
    root /var/www/example.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    error_page 404 /404.html;
    access_log /var/log/nginx/example-access.log;
    error_log /var/log/nginx/example-error.log;
}
EOF
echo "✅ Generated: static-site.conf"

echo ""
echo "[ GENERATING REVERSE PROXY CONFIG ]"
cat > $OUTPUT_DIR/reverse-proxy.conf << 'EOF'
server {
    listen 80;
    server_name api.example.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_connect_timeout 30s;
        proxy_read_timeout 30s;
    }
}
EOF
echo "✅ Generated: reverse-proxy.conf"

echo ""
echo "[ GENERATING LOAD BALANCER CONFIG ]"
cat > $OUTPUT_DIR/load-balancer.conf << 'EOF'
upstream app_cluster {
    least_conn;
    server 10.0.0.1:3000 weight=3;
    server 10.0.0.2:3000 weight=2;
    server 10.0.0.3:3000;
    server 10.0.0.4:3000 backup;
}

server {
    listen 80;
    server_name myapp.example.com;

    location / {
        proxy_pass http://app_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_next_upstream error timeout;
    }

    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
EOF
echo "✅ Generated: load-balancer.conf"

echo ""
echo "[ GENERATING HTTPS REDIRECT CONFIG ]"
cat > $OUTPUT_DIR/https-redirect.conf << 'EOF'
# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name example.com www.example.com;
    return 301 https://$server_name$request_uri;
    # 301 = permanent redirect
    # $server_name = the domain name
    # $request_uri = the path and query string
}

# HTTPS server
server {
    listen 443 ssl;
    server_name example.com www.example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    root /var/www/example.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF
echo "✅ Generated: https-redirect.conf"

echo ""
echo "[ GENERATING MICROSERVICES CONFIG ]"
cat > $OUTPUT_DIR/microservices.conf << 'EOF'
server {
    listen 80;
    server_name myapp.example.com;

    # Route /api/users to user service
    location /api/users {
        proxy_pass http://localhost:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # Route /api/orders to order service
    location /api/orders {
        proxy_pass http://localhost:3002;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # Route /api/payments to payment service
    location /api/payments {
        proxy_pass http://localhost:3003;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # Frontend React app
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
    }
}
EOF
echo "✅ Generated: microservices.conf"

echo ""
echo "[ ALL CONFIGS GENERATED ]"
ls -la $OUTPUT_DIR/
echo ""
echo "To use any config:"
echo "1. sudo cp $OUTPUT_DIR/config.conf /etc/nginx/sites-available/"
echo "2. Edit the config with your actual values"
echo "3. sudo ln -s /etc/nginx/sites-available/config /etc/nginx/sites-enabled/"
echo "4. sudo nginx -t"
echo "5. sudo systemctl reload nginx"

echo ""
echo "============================================"
echo "   GENERATOR COMPLETE"
echo "============================================"
