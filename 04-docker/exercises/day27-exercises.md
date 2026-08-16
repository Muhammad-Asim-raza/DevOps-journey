# Day 27 Exercises — Docker Images & Containers Deep Dive
**Date:** Jul 15 2026
**Status:** ✅ Completed

---

## Exercise 1: Port Mapping ✅
- [x] Ran nginx with -p 8080:80
- [x] Tested access via curl localhost:8080
- [x] Understood host:container format
- [x] Tested multiple port mappings

### Proof
See: practices/day27-practice/exercise1-proof.txt

### Port Mapping Format
-p HOST_PORT:CONTAINER_PORT
-p 8080:80   = your machine:8080 → container:80
-p 0:80      = random host port
-p 127.0.0.1:80:80 = localhost only (secure)

### What I Learned
- Container has its own network namespace
- Internal ports not accessible without mapping
- One container can have multiple -p flags
- docker port container shows mappings

---

## Exercise 2: Environment Variables ✅
- [x] Used -e to set environment variables
- [x] Used --env-file to load from file
- [x] Verified vars inside container with env
- [x] Understood 12-factor app principle

### Proof
See: practices/day27-practice/exercise2-proof.txt

### Key Commands
docker run -e VAR=value image
docker run --env-file app.env image
docker exec container env
docker exec container printenv VAR

### 12-Factor App Rule
Configuration in environment variables
Not hardcoded in image
Same image runs in dev/staging/production
Different env vars = different behavior

---

## Exercise 3: Container Lifecycle ✅
- [x] Used docker create (no start)
- [x] Used docker start
- [x] Used docker pause / unpause
- [x] Used docker stop (graceful)
- [x] Used docker kill (force)
- [x] Used docker restart
- [x] Used docker rm -f (force remove)

### Proof
See: practices/day27-practice/exercise3-proof.txt

### Lifecycle Flow
IMAGE → create → CREATED → start → RUNNING
RUNNING → pause → PAUSED → unpause → RUNNING
RUNNING → stop → STOPPED → start → RUNNING
STOPPED → rm → DELETED (gone forever)

### Restart Policies
no              = never restart
on-failure      = only on error
always          = always restart
unless-stopped  = restart unless manually stopped

---

## Exercise 4: docker exec ✅
- [x] Ran single commands with exec
- [x] Opened interactive shell with -it bash
- [x] Explored container filesystem
- [x] Copied files with docker cp
- [x] Ran commands as specific user

### Proof
See: practices/day27-practice/exercise4-proof.txt

### Key Commands
docker exec container command
docker exec -it container bash
docker exec -u root container whoami
docker cp host_file container:/path/
docker cp container:/path/ host_path

### Important Note
exec only works on RUNNING containers
Container must be started first

---

## Exercise 5: docker logs ✅
- [x] Viewed all logs with docker logs
- [x] Followed live logs with -f
- [x] Showed last N lines with --tail
- [x] Added timestamps with -t
- [x] Filtered by time with --since

### Proof
See: practices/day27-practice/exercise5-proof.txt

### Key Commands
docker logs container          (all logs)
docker logs -f container       (follow live)
docker logs --tail 50 container (last 50)
docker logs -t container       (with timestamps)
docker logs --since 10m container (last 10 min)

---

## Exercise 6: docker inspect ✅
- [x] Inspected running container
- [x] Extracted IP address with --format
- [x] Extracted environment variables
- [x] Inspected image layers
- [x] Compared image sizes

### Proof
See: practices/day27-practice/exercise6-proof.txt

### Useful Inspect Formats
Container IP:
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container

Environment:
docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' container

Status:
docker inspect --format='{{.State.Status}}' container

---

## Exercise 7: Resource Limits ✅
- [x] Applied memory limit with --memory
- [x] Applied CPU limit with --cpus
- [x] Monitored with docker stats
- [x] Inspected limits with docker inspect

### Proof
See: practices/day27-practice/exercise7-proof.txt

### Production Best Practice
Always set limits in production:
docker run \
  --memory="512m" \
  --memory-swap="512m" \
  --cpus="1.0" \
  --restart unless-stopped \
  myapp:v1.0.0

Without limits one container can
consume all server resources

---

## Exercise 8: Image Layers ✅
- [x] Viewed layers with docker history
- [x] Compared alpine vs standard sizes
- [x] Understood caching benefits

### Proof
See: practices/day27-practice/exercise8-proof.txt

### Layer Caching Rule
Change bottom layer → rebuild everything above
Change top layer → only rebuild that layer

Order Dockerfile instructions correctly:
1. Base OS (rarely changes)
2. System dependencies (rarely changes)
3. App dependencies (sometimes changes)
4. App code (changes most often)

---

## Summary
All 8 exercises completed on Jul 15 2026

Scripts written:
- docker-run-reference.sh
- container-lifecycle-demo.sh

Proof files:
- exercise1-proof.txt (port mapping)
- exercise2-proof.txt (env vars)
- exercise3-proof.txt (lifecycle)
- exercise4-proof.txt (exec)
- exercise5-proof.txt (logs)
- exercise6-proof.txt (inspect)
- exercise7-proof.txt (resource limits)
- exercise8-proof.txt (image layers)
- script-output-docker-run.txt
- script-output-lifecycle.txt

Key concepts mastered:
- Port mapping host:container
- Environment variables -e and --env-file
- Complete container lifecycle
- docker exec for debugging
- docker logs for troubleshooting
- docker inspect for deep details
- Resource limits for safety
- Image layers and caching
