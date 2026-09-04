# Day 37 Exercises — Docker Swarm Basics
**Date:** Jul 25 2026
**Status:** ✅ Completed

---

## Exercise 1: Swarm Initialization ✅
- [x] Initialized single-node swarm
- [x] Listed nodes with docker node ls
- [x] Inspected this node
- [x] Retrieved join tokens

### Proof
See: practices/day37-practice/exercise1-proof.txt

### Commands
docker swarm init --advertise-addr 127.0.0.1
docker node ls
docker node inspect self --pretty
docker swarm join-token worker
docker swarm join-token manager

### Key Concepts
Single node = manager AND worker
Production: odd number of managers (3 or 5)
  Raft consensus needs majority (quorum)
  3 managers: survive 1 failure
  5 managers: survive 2 failures

---

## Exercise 2: Docker Services ✅
- [x] Created service with 3 replicas
- [x] Listed services with docker service ls
- [x] Viewed task distribution with docker service ps
- [x] Tested port publishing (routing mesh)
- [x] Viewed combined logs

### Proof
See: practices/day37-practice/exercise2-proof.txt

### Commands
docker service create --name web --replicas 3 --publish 8500:80 nginx:alpine
docker service ls
docker service ps web
docker service logs web
docker service inspect web --pretty

### Key: REPLICAS column
3/3 = 3 running / 3 desired (healthy)
2/3 = 2 running / 3 desired (problem!)

---

## Exercise 3: Service Scaling ✅
- [x] Scaled up to 5 replicas
- [x] Scaled down to 2 replicas
- [x] Scaled multiple services at once
- [x] Verified zero downtime during scaling

### Proof
See: practices/day37-practice/exercise3-proof.txt

### Commands
docker service scale web=5
docker service scale web=2
docker service scale web=4 api=3

### Zero Downtime
Swarm never drops below minimum replicas
New replicas start BEFORE count is reduced
Traffic always served during scaling

---

## Exercise 4: Rolling Updates and Rollbacks ✅
- [x] Built v1, v2, and broken v3 images
- [x] Created service with update config
- [x] Performed rolling update v1 → v2
- [x] Watched replicas update one batch at a time
- [x] Deployed broken v3 → auto-rollback triggered
- [x] Verified rollback restored v2

### Proof
See: practices/day37-practice/exercise4-proof.txt
See: practices/day37-practice/swarm-demo/app/

### Key Flags
--update-parallelism 2     = update 2 at a time
--update-delay 10s         = wait between batches
--update-failure-action rollback = auto rollback!
--rollback-parallelism 2

### How Auto-rollback Works
1. Start updating replicas
2. Health check fails on new version
3. Failure count exceeds max_failure_ratio
4. Swarm automatically reverts to previous image
5. No manual intervention needed

---

## Exercise 5: Overlay Networks ✅
- [x] Viewed default swarm networks
- [x] Created custom overlay network
- [x] Deployed services on overlay
- [x] Verified service-to-service DNS
- [x] Understood routing mesh

### Proof
See: practices/day37-practice/exercise5-proof.txt

### Network Types in Swarm
ingress = routing mesh (built-in)
          any port on any node → any container
overlay = custom service communication
          encrypted by default in Swarm

### DNS in Swarm
Service name resolves to VIP (Virtual IP)
VIP load-balances to all healthy replicas
Works across nodes automatically

---

## Exercise 6: Swarm Secrets ✅
- [x] Created secrets with stdin
- [x] Listed secrets (names only, no values)
- [x] Inspected secret metadata
- [x] Understood /run/secrets/ mounting

### Proof
See: practices/day37-practice/exercise6-proof.txt

### Secret vs Environment Variable
ENV:    visible in docker inspect, ps aux, logs
Secret: encrypted at rest, only in /run/secrets/
        never in environment, inspect, or logs

### Application Reading Secrets
password = open('/run/secrets/db_password').read().strip()
           # Reads from mounted file, not env var

---

## Exercise 7: Stack Deployment ✅
- [x] Created docker-stack.yml with deploy section
- [x] Deployed stack with docker stack deploy
- [x] Listed stacks and services
- [x] Listed all tasks in stack
- [x] Removed stack

### Proof
See: practices/day37-practice/exercise7-proof.txt
See: practices/day37-practice/swarm-demo/stacks/

### Key Compose Additions for Swarm
deploy:
  replicas: 3
  update_config:
    parallelism: 1
    delay: 10s
    failure_action: rollback
  rollback_config:
    parallelism: 1
  restart_policy:
    condition: on-failure
    max_attempts: 3
  resources:
    limits:
      memory: 256M
      cpus: '0.5'
  placement:
    constraints:
      - node.role == worker

### Stack Commands
docker stack deploy -c file.yml name
docker stack ls
docker stack services name
docker stack ps name
docker stack rm name

---

## Swarm vs Kubernetes Summary

### Use Swarm When
Small team, simple deployment
Don't need auto-scaling
No Kubernetes expertise
Quick setup needed
docker-compose experience to leverage

### Use Kubernetes When
Large scale (hundreds of services)
Auto-scaling required
Rich ecosystem needed
Cloud provider managed (EKS/GKE/AKS)
Complex networking required
This is what most companies use

---

## Summary
All 7 exercises completed on Jul 25 2026

Scripts written:
- swarm-reference.sh

Applications built:
- swarm-app:v1 (blue version)
- swarm-app:v2 (green version)
- swarm-app:v3-broken (for rollback demo)

Proof files:
- exercise1-proof.txt (swarm init)
- exercise2-proof.txt (services)
- exercise3-proof.txt (scaling)
- exercise4-proof.txt (rolling updates)
- exercise5-proof.txt (overlay networks)
- exercise6-proof.txt (secrets)
- exercise7-proof.txt (stack deploy)
- script-output-swarm.txt

Key concepts mastered:
- WHY orchestration exists
- Swarm vs Kubernetes tradeoffs
- Node types: manager vs worker
- Service vs container
- Rolling updates with auto-rollback
- Overlay networks (multi-host)
- Routing mesh (any node serves any replica)
- Swarm secrets (encrypted)
- Stack deployment (Compose for Swarm)
- Placement constraints
