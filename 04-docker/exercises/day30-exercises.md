# Day 30 Exercises — Docker Networking
**Date:** Jul 18 2026
**Status:** ✅ Completed

---

## Exercise 1: Default Bridge Network ✅
- [x] Listed networks with docker network ls
- [x] Inspected default bridge network
- [x] Ran two containers on default bridge
- [x] Pinged by IP (works)
- [x] Pinged by name (FAILS - no DNS)

### Proof
See: practices/day30-practice/exercise1-proof.txt

### Key Insight
Default bridge = no automatic DNS
Must use IP addresses
IPs change on restart
This is why custom networks are needed

---

## Exercise 2: Custom Bridge Networks ✅
- [x] Created custom network
- [x] Ran containers on custom network
- [x] Pinged by container NAME (works!)
- [x] Inspected network topology
- [x] Used connect/disconnect

### Proof
See: practices/day30-practice/exercise2-proof.txt

### Commands Used
docker network create devops-network
docker run --network devops-network --name svc nginx
docker exec svc ping -c 2 other-svc
docker network connect devops-network container
docker network disconnect devops-network container

### DNS Works on Custom Networks
Container name resolves automatically
db_host=postgres  (just use the name!)
redis_host=redis  (just use the name!)
No IP addresses needed ever

---

## Exercise 3: Network Isolation ✅
- [x] Created two separate networks
- [x] Frontend on frontend-net only
- [x] Database on backend-net only
- [x] Backend connected to BOTH networks
- [x] Verified frontend cannot reach database
- [x] Verified backend can reach both

### Proof
See: practices/day30-practice/exercise3-proof.txt

### Security Architecture
Internet → frontend-net → backend-net → database

frontend: CANNOT reach database (different network)
backend:  CAN reach both (connected to both)
database: NOT exposed to internet (no -p)

This is defense in depth with networking

---

## Exercise 4: Host and None Networks ✅
- [x] Ran with --network host
- [x] Verified host network is shared
- [x] Ran with --network none
- [x] Verified complete isolation

### Proof
See: practices/day30-practice/exercise4-proof.txt

### When to Use
host: network tools, monitoring, performance
none: maximum security, batch processing
      running untrusted code safely

---

## Exercise 5: Multi-Container Application ✅
- [x] Built 3-container application stack
- [x] nginx frontend proxy
- [x] Python backend API
- [x] Redis cache
- [x] All on shared custom network
- [x] nginx proxies requests to backend by name
- [x] Tested full stack with curl

### Proof
See: practices/day30-practice/exercise5-proof.txt

### Stack Architecture
nginx:80 (exposed -p 8600:80)
    ↓ proxy_pass http://backend-api:5000
backend-api:5000 (NOT exposed, internal)
    ↓ connects to
cache:6379 (NOT exposed, internal)

Container names used as hostnames
No port mapping needed between containers

---

## Exercise 6: Network Commands Reference ✅
- [x] Practiced all network commands
- [x] Tested connect/disconnect at runtime
- [x] Verified container gets second IP

### Proof
See: practices/day30-practice/exercise6-proof.txt

### Complete Command Reference
docker network ls                     (list)
docker network create name            (create)
docker network inspect name           (details)
docker network connect net container  (add)
docker network disconnect net cont    (remove)
docker network rm name                (delete)
docker network prune                  (cleanup)

---

## Key Networking Concepts

### DNS Resolution
Custom networks: container name = hostname ✅
Default bridge: must use IP address ❌

### Port Exposure
Container to container: no -p needed
                        all ports accessible on same network
External to container: -p host:container required

### Network Isolation Security Pattern
frontend-network: nginx, backend
backend-network:  backend, database, cache
backend: connected to BOTH networks
database: ONLY on backend-network (secure!)

### Container Network Addresses
Default bridge: 172.17.0.0/16
Custom networks: assigned automatically or configured

---

## Summary
All 6 exercises completed on Jul 18 2026

Scripts written:
- docker-networking.sh

Multi-container app built:
- backend.py + Dockerfile
- nginx.conf

Proof files:
- exercise1-proof.txt (default bridge)
- exercise2-proof.txt (custom bridge + DNS)
- exercise3-proof.txt (isolation)
- exercise4-proof.txt (host and none)
- exercise5-proof.txt (multi-container app)
- exercise6-proof.txt (commands reference)
- script-output-networking.txt

Key concepts mastered:
- Docker network types (bridge/host/none)
- Custom networks with automatic DNS
- Container name as hostname
- Network isolation for security
- Multi-tier network architecture
- connect/disconnect at runtime
- Port exposure rules
