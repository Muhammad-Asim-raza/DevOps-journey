# Day 13 Exercises — SSL/TLS Certificates and HTTPS
**Date:** Jul 03 2026
**Status:** ✅ Completed

---

## Exercise 1: Self-Signed Certificate ✅
- [x] Installed OpenSSL
- [x] Generated RSA 2048-bit key pair
- [x] Created self-signed certificate
- [x] Viewed certificate details
- [x] Understood certificate fields

### Proof
See: practices/day13-practice/exercise1-proof.txt
See: practices/day13-practice/certs/

### Command Used
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout certs/self-signed.key \
    -out certs/self-signed.crt \
    -subj "/C=PK/ST=KPK/L=DIKhan/O=DevOpsJourney/CN=localhost"

### Flags Explained
-x509      = self-signed (not a request)
-nodes     = no password on private key
-days 365  = valid for 1 year
-newkey rsa:2048 = generate 2048-bit RSA key
-keyout    = save private key here
-out       = save certificate here
-subj      = certificate identity info

### What I Learned
- Certificates contain: subject, validity, public key
- Private key must be kept SECRET always
- Certificate (public) is shared with nginx
- Self-signed not trusted by browsers
- Use for: testing, internal tools, development

---

## Exercise 2: nginx HTTPS Configuration ✅
- [x] Created HTTPS server block
- [x] Added ssl_certificate directive
- [x] Added ssl_certificate_key directive
- [x] Configured TLS protocols
- [x] Added HSTS header
- [x] Set up HTTP → HTTPS redirect
- [x] Tested with curl -k

### Proof
See: practices/day13-practice/exercise2-proof.txt
See: /etc/nginx/sites-available/https-site

### Key nginx SSL Directives
listen 443 ssl         = HTTPS port
ssl_certificate        = path to .crt file
ssl_certificate_key    = path to .key file
ssl_protocols          = TLSv1.2 TLSv1.3 only
ssl_session_cache      = performance optimization
HSTS header            = force HTTPS in browser

### What I Learned
- nginx needs both cert and key files
- TLS 1.2 and 1.3 only (disable old versions)
- HSTS tells browsers to always use HTTPS
- HTTP redirect: return 301 https://...
- curl -k ignores cert warning (testing only)

---

## Exercise 3: Let's Encrypt and Certbot ✅
- [x] Installed certbot and nginx plugin
- [x] Learned domain validation process
- [x] Studied HTTP-01 challenge
- [x] Learned certificate file locations
- [x] Reviewed auto-renewal timer
- [x] Created production nginx template

### Proof
See: practices/day13-practice/exercise3-proof.txt
See: practices/day13-practice/nginx-ssl-configs/letsencrypt-site.conf

### Commands for Production
sudo certbot --nginx -d mysite.com
sudo certbot renew --dry-run
sudo certbot certificates
sudo systemctl status certbot.timer

### Certificate Locations
/etc/letsencrypt/live/domain/
├── fullchain.pem  → ssl_certificate
├── privkey.pem    → ssl_certificate_key
├── cert.pem       → certificate only
└── chain.pem      → CA chain only

### What I Learned
- Let's Encrypt = FREE trusted certificates
- Certbot automates everything
- HTTP-01 challenge verifies domain ownership
- Certs expire in 90 days (auto-renewed at 60)
- certbot.timer runs twice daily
- Never need to manually renew

---

## Exercise 4: SSL Security Testing ✅
- [x] Tested TLS version support
- [x] Checked certificate expiry dates
- [x] Verified cipher suites
- [x] Used openssl s_client for testing

### Proof
See: practices/day13-practice/exercise4-proof.txt

### SSL Testing Commands
openssl s_client -connect host:port
openssl x509 -in cert.crt -text -noout
openssl x509 -noout -dates -in cert.crt
openssl x509 -noout -checkend 2592000

### What I Learned
- openssl s_client = SSL debugging tool
- Always check: protocol version, cipher, expiry
- checkend 0 = is cert currently valid?
- checkend 2592000 = valid for 30 more days?
- Monitor certs before they expire

---

## Exercise 5: SSL Scripts ✅
- [x] ssl-checker.sh written and working
- [x] cert-monitor.sh written and working
- [x] Outputs saved as proof

### Proof
See: practices/day13-practice/ssl-checker.sh
See: practices/day13-practice/cert-monitor.sh
See: practices/day13-practice/script-output-ssl-checker.txt
See: practices/day13-practice/script-output-cert-monitor.txt

---

## SSL Best Practices I Learned
- Only use TLS 1.2 and 1.3 (disable older)
- Use strong cipher suites with ECDHE
- Enable HSTS (but be careful - hard to undo)
- Enable OCSP stapling for performance
- Monitor certificate expiry (alert at 30 days)
- Never commit private keys to git
- Use Let's Encrypt for production (free)
- Use self-signed for internal/testing
- Always redirect HTTP to HTTPS (301)
- Enable HTTP/2 for performance

---

## Summary
All 5 exercises completed on Jul 03 2026

Scripts written:
- ssl-checker.sh (certificate verification tool)
- cert-monitor.sh (expiry monitoring tool)

Certificate files created:
- certs/self-signed.key (private key)
- certs/self-signed.crt (certificate)

nginx Configs:
- /etc/nginx/sites-available/https-site
- nginx-ssl-configs/letsencrypt-site.conf

Proof files:
- exercise1-proof.txt (self-signed cert)
- exercise2-proof.txt (nginx HTTPS)
- exercise3-proof.txt (certbot)
- exercise4-proof.txt (SSL testing)
- script-output-ssl-checker.txt
- script-output-cert-monitor.txt

Key concepts learned:
- SSL vs TLS history and difference
- TLS handshake process
- Certificate anatomy (subject validity key)
- Certificate Authorities (CA)
- Certificate types (DV OV EV wildcard)
- Self-signed certificates with openssl
- nginx HTTPS configuration
- Let's Encrypt and certbot automation
- Domain validation (HTTP-01 DNS-01)
- SSL security testing with openssl
- Certificate monitoring and renewal
