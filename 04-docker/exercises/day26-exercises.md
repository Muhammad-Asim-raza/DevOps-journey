# Day 26 Exercises — What Are Containers & Why Docker
**Date:** Jul 14 2026
**Status:** ✅ Completed

---

## Exercise 1: Docker Installation ✅
- [x] Installed Docker CE on Ubuntu
- [x] Added user to docker group
- [x] Verified with docker --version
- [x] Ran docker info to check system

### Proof
See: practices/day26-practice/exercise1-proof.txt

### Installation Commands
sudo apt install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
newgrp docker
docker --version

### What I Learned
- Docker CE = Community Edition (free)
- containerd = actual container runtime
- docker group = no sudo needed
- Docker daemon runs as systemd service

---

## Exercise 2: First Docker Commands ✅
- [x] Ran hello-world container
- [x] Used docker ps -a to see containers
- [x] Used docker images to see images
- [x] Pulled ubuntu:22.04 image
- [x] Ran interactive Ubuntu container

### Proof
See: practices/day26-practice/exercise2-proof.txt

### Commands Used
docker run hello-world
docker ps -a
docker images
docker pull ubuntu:22.04
docker run -it ubuntu:22.04 bash
docker run -d nginx

### Key Flags
-d = detached (background)
-i = interactive (keep stdin)
-t = TTY (terminal)
-it = interactive terminal
--name = give container a name

---

## Exercise 3: Images vs Containers ✅
- [x] Created 3 containers from 1 image
- [x] Verified each has unique hostname
- [x] Understood image = template
- [x] Understood container = running instance

### Proof
See: practices/day26-practice/exercise3-proof.txt

### Key Insight
Image = cookie cutter (one mold)
Container = cookie (many from one mold)
One nginx image → 1000 containers possible
Each container is independent

### Commands Used
docker run -d --name web1 nginx
docker exec web1 hostname
docker stop web1
docker rm web1

---

## Exercise 4: Docker Hub ✅
- [x] Searched Docker Hub from CLI
- [x] Pulled images with specific tags
- [x] Compared image sizes
- [x] Viewed image layers with history

### Proof
See: practices/day26-practice/exercise4-proof.txt

### Image Tags Learned
:latest = most recent
:alpine = Alpine Linux (tiny ~5MB base)
:slim = stripped down
:1.25 = specific version (pin this in production!)

### Important: Always Pin Versions in Production
nginx:latest  ← version changes unexpectedly
nginx:1.25.3  ← stable, predictable

---

## Exercise 5: Docker Cleanup ✅
- [x] Checked disk usage with docker system df
- [x] Learned prune commands
- [x] Understood cleanup hierarchy

### Proof
See: practices/day26-practice/exercise5-proof.txt

### Cleanup Commands
docker container prune     = remove stopped containers
docker image prune -a      = remove unused images
docker system prune -a     = remove EVERYTHING unused
docker system df           = check disk usage

---

## Key Concepts Learned Today

### Problem Containers Solve
"Works on my machine" syndrome
Different environments = different results
Containers package app WITH dependencies
Runs identically everywhere

### Containers vs VMs
Containers: Share OS kernel, MB size, ms startup
VMs: Full OS copy, GB size, minutes startup

### Docker Components
Client (CLI) → Daemon (engine) → Registry (Hub)

### Image Naming
nginx:alpine   = official + alpine tag
user/app:v1.0  = username/image:version
registry/img   = private registry

---

## Summary
All 5 exercises completed on Jul 14 2026

Scripts written:
- docker-basics.sh (complete reference)

Proof files:
- exercise1-proof.txt (installation)
- exercise2-proof.txt (first commands)
- exercise3-proof.txt (images vs containers)
- exercise4-proof.txt (Docker Hub)
- exercise5-proof.txt (cleanup)
- script-output-docker-basics.txt

Key concepts learned:
- WHY containers exist (the problem)
- What a container is technically
- Containers vs VMs comparison
- Docker architecture (client/daemon/registry)
- Docker terminology (image/container/tag/layer)
- Docker Hub and image naming
- Core Docker commands
- Docker cleanup
