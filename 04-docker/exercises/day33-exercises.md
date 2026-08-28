# Day 33 Exercises — Docker Security Best Practices
**Date:** Jul 21 2026
**Status:** ✅ Completed

---

## Exercise 1: Non-Root User ✅
- [x] Showed default containers run as root
- [x] Created secure Dockerfile with non-root user
- [x] Verified app runs as UID 1001
- [x] Built with minimal permissions (chmod 440)

### Proof
See: practices/day33-practice/exercise1-proof.txt
See: practices/day33-practice/secure-app/Dockerfile.secure

### Non-Root Pattern
RUN groupadd --gid 1001 --system appgroup && \
    useradd --uid 1001 --gid appgroup \
            --system --no-create-home \
            --shell /bin/false appuser
RUN chown -R appuser:appgroup /app
USER appuser

### Why It Matters
Root in container + escape vulnerability = root on host
Non-root in container + escape = limited user on host
Blast radius reduced dramatically

---

## Exercise 2: Read-Only Filesystem ✅
- [x] Ran container with --read-only
- [x] Verified writes blocked to /app
- [x] Added tmpfs for /tmp writes
- [x] Verified /tmp writes work with tmpfs

### Proof
See: practices/day33-practice/exercise2-proof.txt

### Command
docker run --read-only \
    --tmpfs /tmp:rw,noexec,nosuid,size=64m \
    myapp:v1.0

### Locations Needing tmpfs
/tmp = temporary files
/var/cache = caches
/var/log = if app writes logs
Note: set ENV PYTHONDONTWRITEBYTECODE=1
      so Python doesn't write .pyc files

---

## Exercise 3: Linux Capabilities ✅
- [x] Understood default capabilities (too many)
- [x] Dropped all with --cap-drop ALL
- [x] Added back only needed capability
- [x] Added --security-opt no-new-privileges

### Proof
See: practices/day33-practice/exercise3-proof.txt

### Production Pattern
docker run \
  --cap-drop ALL \
  --cap-add NET_BIND_SERVICE \
  --security-opt no-new-privileges:true \
  myapp:v1.0

### Common Capabilities Needed
NET_BIND_SERVICE = bind to port < 1024
CHOWN           = change file ownership
SETUID/SETGID   = if needed (avoid)

### NEVER USE
--privileged = gives EVERYTHING (root on host)

---

## Exercise 4: Image Scanning with Trivy ✅
- [x] Installed Trivy scanner
- [x] Scanned secure-app image
- [x] Scanned Dockerfile for misconfigs
- [x] Scanned filesystem for secrets
- [x] Understood CVE severity levels

### Proof
See: practices/day33-practice/exercise4-proof.txt
See: practices/day33-practice/scanning/scan-results.json

### Commands
trivy image --severity HIGH,CRITICAL myapp:v1.0
trivy image --format json --output results.json myapp
trivy config ./  (Dockerfile misconfigs)
trivy fs --scanners secret ./  (find secrets)

### CVE Severities
CRITICAL = fix immediately (RCE possible)
HIGH     = fix soon (serious vulnerability)
MEDIUM   = fix in next sprint
LOW      = fix when convenient
INFO     = informational only

---

## Exercise 5: Secrets Management ✅
- [x] Understood wrong ways (ENV, -e, compose)
- [x] Used --env-file correctly
- [x] Learned Docker secrets (Swarm)
- [x] Learned BuildKit secret injection
- [x] Understood AWS Secrets Manager

### Proof
See: practices/day33-practice/exercise5-proof.txt

### Secrets Priority (worst to best)
1. ENV in Dockerfile     ← WORST
2. docker run -e         ← in history
3. docker-compose.yml    ← in Git
4. .env file             ← not committed
5. Docker secrets        ← encrypted
6. Kubernetes secrets    ← encrypted
7. AWS Secrets Manager   ← BEST
8. HashiCorp Vault       ← BEST

---

## Production Security Template

### Secure docker run
docker run -d \
  --read-only \
  --cap-drop ALL \
  --cap-add NET_BIND_SERVICE \
  --security-opt no-new-privileges:true \
  --pids-limit 100 \
  --memory 512m \
  --memory-swap 512m \
  --cpus 1.0 \
  --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  --env-file .env \
  --restart unless-stopped \
  myapp:v1.0.0

### Secure Dockerfile Checklist
✅ FROM python:3.11-slim (specific version)
✅ RUN apt-get update && apt-get upgrade -y
✅ Create non-root user with specific UID
✅ Set ENV PYTHONDONTWRITEBYTECODE=1
✅ chown files before USER switch
✅ USER appuser
✅ HEALTHCHECK configured
✅ No secrets in ENV or ARG
✅ Minimal permissions (chmod 440)

---

## Summary
All 5 exercises completed on Jul 21 2026

Scripts written:
- docker-security-reference.sh (reference)

Images:
- secure-app:v1.0 (security hardened)

Proof files:
- exercise1-proof.txt (non-root)
- exercise2-proof.txt (read-only fs)
- exercise3-proof.txt (capabilities)
- exercise4-proof.txt (Trivy scanning)
- exercise5-proof.txt (secrets)
- script-output-security.txt

Key concepts mastered:
- Container runs as non-root
- Read-only filesystem + tmpfs
- Drop all Linux capabilities
- no-new-privileges security option
- Trivy image scanning
- CVE severity levels
- Secrets management hierarchy
- Production secure run template
