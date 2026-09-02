# Day 35 Exercises — Docker in Production Patterns
**Date:** Jul 23 2026
**Status:** ✅ Completed

---

## Exercise 1: Health Checks Deep Dive ✅
- [x] Built app with /health /ready /live endpoints
- [x] Watched health status transition: starting → healthy
- [x] Tested all three health check types
- [x] Read health check logs from docker inspect

### Proof
See: practices/day35-practice/exercise1-proof.txt
See: practices/day35-practice/health-demo/

### Three Health Endpoints
/health  = is process alive? (Docker HEALTHCHECK)
/ready   = ready for traffic? (K8s readinessProbe)
/live    = in good state? (K8s livenessProbe)

### Health States
starting  = grace period (start_period)
healthy   = load balancer: send traffic
unhealthy = load balancer: stop, restart container

### HEALTHCHECK Parameters
--interval=30s    = check every 30 seconds
--timeout=5s      = fail if takes > 5s
--start-period=20s = grace period after start
--retries=3       = unhealthy after 3 failures

---

## Exercise 2: Graceful Shutdown ✅
- [x] Implemented SIGTERM handler in Python
- [x] Handler stops new requests
- [x] Handler waits for in-flight requests
- [x] Used docker stop --time 30
- [x] Verified shutdown logs

### Proof
See: practices/day35-practice/exercise2-proof.txt
See: practices/day35-practice/production-app/app/graceful_app.py

### Graceful Shutdown Flow
1. docker stop sends SIGTERM
2. App catches SIGTERM signal
3. Health returns 503 (LB stops routing)
4. Wait for in-flight requests to finish
5. Close database connections
6. Exit cleanly (code 0)

### Docker Config
STOPSIGNAL SIGTERM (Dockerfile)
stop_grace_period: 35s (Compose)
docker stop --time 30 container

---

## Exercise 3: Log Management ✅
- [x] Built app with JSON structured logging
- [x] Configured log rotation (max-size, max-file)
- [x] Parsed structured logs with Python
- [x] Learned available log drivers

### Proof
See: practices/day35-practice/exercise3-proof.txt
See: practices/day35-practice/logging-demo/

### Log Rotation Config
docker run \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  myapp:v1.0

Max storage: 3 × 10MB = 30MB
Prevents disk filling up!

### Structured Logging Benefits
{"level": "ERROR", "message": "DB connection failed", ...}
Machine parseable = queryable
Filter by level, timestamp, service
Works with: CloudWatch, Elasticsearch, Splunk

---

## Exercise 4: Production Compose ✅
- [x] Used YAML anchors (&anchor /*alias)
- [x] x-logging for uniform log config
- [x] deploy.resources for memory/CPU limits
- [x] read_only: true for security
- [x] stop_grace_period for graceful shutdown
- [x] internal: true network for DB isolation
- [x] :? required variables syntax

### Proof
See: practices/day35-practice/exercise4-proof.txt
See: practices/day35-practice/production-app/docker-compose.yml

### Key Compose Production Patterns
YAML anchors:
  x-logging: &logging (define)
  logging: *logging   (use)

Required variables:
  DB_PASSWORD: ${DB_PASSWORD:?Required!}

Internal networks:
  backend:
    internal: true  (no internet for DB)

Graceful shutdown:
  stop_grace_period: 35s

---

## Production Readiness Checklist

### Image Level
✅ Specific version tag
✅ Multi-stage build
✅ Non-root user (USER appuser)
✅ HEALTHCHECK in Dockerfile
✅ No secrets in image
✅ Labels with metadata
✅ Vulnerability scan passed

### Container Level
✅ --read-only filesystem
✅ --cap-drop ALL
✅ --security-opt no-new-privileges
✅ Memory and CPU limits
✅ --restart unless-stopped
✅ Log rotation configured
✅ Sufficient stop timeout

### Architecture Level
✅ Custom networks (not default bridge)
✅ DB on internal network
✅ Only proxy exposed externally
✅ Named volumes for persistence
✅ .env.example in Git, .env in .gitignore

---

## Summary
All 4 exercises completed on Jul 23 2026

Scripts written:
- production-patterns-reference.sh

Applications built:
- health-demo (3 health endpoints)
- graceful-app (SIGTERM handler)
- logging-demo (JSON structured logs)
- production-app (full production stack)

Proof files:
- exercise1-proof.txt (health checks)
- exercise2-proof.txt (graceful shutdown)
- exercise3-proof.txt (log management)
- exercise4-proof.txt (production compose)
- script-output-production.txt

Key concepts mastered:
- Health check states and transitions
- Three health endpoints (health/ready/live)
- SIGTERM signal handling
- Graceful shutdown pattern
- JSON structured logging
- Log rotation configuration
- YAML anchors in Compose
- Internal networks for security
- Required variables with :?
- Production readiness checklist
