# Day 31 Exercises — Docker Compose
**Date:** Jul 19 2026
**Status:** ✅ Completed

---

## Exercise 1: First Compose File ✅
- [x] Created docker-compose.yml with 2 services
- [x] Used docker compose up -d
- [x] Used docker compose ps
- [x] Used docker compose logs
- [x] Used docker compose exec
- [x] Used docker compose down -v

### Proof
See: practices/day31-practice/exercise1-proof.txt
See: practices/day31-practice/hello-compose/docker-compose.yml

### Commands Learned
docker compose up -d          (start all)
docker compose ps             (status)
docker compose logs -f        (live logs)
docker compose exec svc cmd   (run in service)
docker compose down           (stop and remove)
docker compose down -v        (also remove volumes)

### What I Learned
- One file replaces multiple docker run commands
- Services defined as YAML keys
- Networks and volumes declared at bottom
- Compose auto-creates project prefix on resources

---

## Exercise 2: Full Stack Application ✅
- [x] Built 4-service application stack
- [x] nginx + backend + redis + postgres
- [x] Used build: context for custom image
- [x] Used depends_on with condition: service_healthy
- [x] Used ${VARIABLE:-default} for env vars
- [x] Tested all endpoints through nginx proxy

### Proof
See: practices/day31-practice/exercise2-proof.txt
See: practices/day31-practice/full-stack-app/docker-compose.yml

### Stack Architecture
nginx:8800 (exposed)
  ↓ proxy /api/ → 
backend:5000 (internal only)
  ↓ connects to
redis:6379 (internal only)
postgres:5432 (internal only)

### Key Patterns Used
build: context to build from Dockerfile
depends_on: condition: service_healthy
${DB_PASSWORD:-devops123} default values
Two networks: frontend-net and backend-net

---


### Variable Management
Use .env file for defaults
Use ${VAR:-default} for fallbacks
Never hardcode secrets in compose file
Add .env to .gitignore
Commit .env.example to Git

### depends_on vs healthcheck
depends_on: starts services in order
            but does NOT wait for ready!
condition: service_healthy: WAITS for healthcheck
Always add healthchecks to databases!

### Naming Convention
Project name = directory name
Container: projectname_service_1
Network: projectname_networkname
Volume: projectname_volumename

Override with COMPOSE_PROJECT_NAME= in .env

### One File Per Environment
docker-compose.yml          = shared base
docker-compose.override.yml = local dev (auto)
docker-compose.staging.yml  = staging
docker-compose.prod.yml     = production

---

## Summary
All 2 exercises completed on Jul 19 2026

Scripts written:
- compose-reference.sh

Compose files created:
- hello-compose/docker-compose.yml
- full-stack-app/docker-compose.yml
- full-stack-app/docker-compose.override.yml
- full-stack-app/docker-compose.prod.yml
- full-stack-app/.env.example

Application built:
- backend/ (Python API with Redis)
- nginx/ (reverse proxy config)

Proof files:
- exercise1-proof.txt (first compose)
- exercise2-proof.txt (full stack)


Key concepts mastered:
- docker-compose.yml structure and all directives
- All core compose commands
- Multi-service application orchestration
- depends_on with health conditions
- Environment variable substitution
- Named volumes and networks in Compose
- Override files for environments
- Build vs image directives
- Service scaling
