#!/bin/bash
# ================================================
# docker-security-reference.sh
# Docker Security Complete Reference
# Author: Asim Raza
# Day 33 of DevOps Journey
# ================================================

echo "============================================"
echo "   DOCKER SECURITY REFERENCE"
echo "   Author: Asim Raza - Day 33"
echo "============================================"

echo ""
echo "[ THE 10 DOCKER SECURITY RULES ]"
echo ""
echo "  1. NEVER run as root"
echo "     RUN useradd -m appuser && USER appuser"
echo ""
echo "  2. Use read-only filesystem"
echo "     docker run --read-only myapp"
echo ""
echo "  3. Drop all capabilities"
echo "     docker run --cap-drop ALL --cap-add NET_BIND_SERVICE"
echo ""
echo "  4. No new privileges"
echo "     docker run --security-opt no-new-privileges:true"
echo ""
echo "  5. Never use :latest in production"
echo "     myapp:v1.0.0 not myapp:latest"
echo ""
echo "  6. Scan images for vulnerabilities"
echo "     trivy image myapp:v1.0.0"
echo ""
echo "  7. Keep base images updated"
echo "     RUN apt-get update && apt-get upgrade -y"
echo ""
echo "  8. Never store secrets in images"
echo "     Use: --env-file, Docker secrets, AWS SM"
echo ""
echo "  9. Never mount Docker socket"
echo "     -v /var/run/docker.sock:/var/run/docker.sock"
echo "     = full host takeover possible"
echo ""
echo " 10. Set resource limits"
echo "     --memory 512m --cpus 1.0"

echo ""
echo "[ SECURITY FLAGS REFERENCE ]"
echo ""
echo "  --read-only"
echo "    Container filesystem is read-only"
echo ""
echo "  --cap-drop ALL"
echo "    Drop all Linux capabilities"
echo ""
echo "  --cap-add CAP_NAME"
echo "    Add back specific capability"
echo "    Common ones: NET_BIND_SERVICE, CHOWN, SETUID"
echo ""
echo "  --security-opt no-new-privileges:true"
echo "    Cannot gain new privileges via setuid"
echo ""
echo "  --security-opt seccomp=profile.json"
echo "    Restrict system calls (advanced)"
echo ""
echo "  --pids-limit 100"
echo "    Limit process count (prevents fork bombs)"
echo ""
echo "  --memory 512m"
echo "    Limit RAM (prevents memory exhaustion)"
echo ""
echo "  --cpus 0.5"
echo "    Limit CPU (prevents CPU exhaustion)"
echo ""
echo "  --tmpfs /tmp:rw,noexec,nosuid,size=64m"
echo "    Allow temp writes in memory"
echo "    noexec = cannot execute files"
echo "    nosuid = ignore setuid bits"
echo "    size = maximum size"

echo ""
echo "[ DOCKERFILE SECURITY CHECKLIST ]"
echo "  ✅ FROM image:SPECIFIC_VERSION (not :latest)"
echo "  ✅ RUN apt-get upgrade -y (update base packages)"
echo "  ✅ RUN useradd --system --no-create-home appuser"
echo "  ✅ USER appuser (switch before CMD)"
echo "  ✅ COPY specific files (not COPY . .)"
echo "  ✅ ENV PYTHONDONTWRITEBYTECODE=1 (for read-only fs)"
echo "  ✅ HEALTHCHECK defined"
echo "  ✅ No secrets in ENV or ARG"
echo "  ✅ Minimal final image (slim/alpine)"
echo "  ✅ Multi-stage build (no dev tools in prod)"

echo ""
echo "[ VULNERABILITY SCANNING ]"
echo "  trivy image myapp:v1.0"
echo "  trivy image --severity HIGH,CRITICAL myapp"
echo "  trivy config ./  (scan Dockerfiles)"
echo "  trivy fs --scanners secret ./"

echo ""
echo "[ SECRETS IN ORDER OF SECURITY ]"
echo "  Worst to best:"
echo "  1. In Dockerfile ENV    (worst - in image)"
echo "  2. docker run -e        (in shell history)"
echo "  3. docker-compose.yml   (in Git)"
echo "  4. .env file            (not committed)"
echo "  5. Docker secrets       (encrypted, Swarm)"
echo "  6. Kubernetes secrets   (encrypted, k8s)"
echo "  7. AWS Secrets Manager  (best - external)"
echo "  8. HashiCorp Vault      (best - external)"

echo ""
echo "[ PRODUCTION SECURE RUN TEMPLATE ]"
cat << 'EOF'
docker run -d \
  --name myapp \
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
  -p 8080:8000 \
  myapp:v1.0.0
EOF

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
