# Day 29 Exercises — Docker Volumes & Data Persistence
**Date:** Jul 17 2026
**Status:** ✅ Completed

---

## Exercise 1: Named Volumes ✅
- [x] Created volume with docker volume create
- [x] Wrote data from Container 1
- [x] Verified data survives in Container 2
- [x] Inspected volume with docker volume inspect
- [x] Listed volumes with docker volume ls

### Proof
See: practices/day29-practice/exercise1-proof.txt

### Commands Used
docker volume create devops-data
docker run -v devops-data:/data ubuntu bash -c "echo text > /data/file"
docker volume ls
docker volume inspect devops-data
docker volume rm devops-data

### What I Learned
- Volumes managed by Docker
- Stored at /var/lib/docker/volumes/
- Survive container deletion
- Shared between multiple containers
- Best for: databases, persistent data

---

## Exercise 2: Bind Mounts ✅
- [x] Mounted host directory into container
- [x] Edited file on host, container saw change
- [x] Container wrote file visible on host
- [x] Tested read-only :ro mount

### Proof
See: practices/day29-practice/exercise2-proof.txt

### Bind Mount Syntax
-v /host/absolute/path:/container/path
-v $(pwd):/app          (current directory)
-v $(pwd):/app:ro       (read-only)

### Use Cases
Development: live code editing
Config files: mount nginx.conf read-only
SSL certs: mount certificate read-only
Scripts: mount backup scripts

---

## Exercise 3: Database Persistence ✅
- [x] Created PostgreSQL with named volume
- [x] Inserted data into database
- [x] Deleted the container completely
- [x] Recreated container with same volume
- [x] Verified all data survived

### Proof
See: practices/day29-practice/exercise3-proof.txt

### Critical Pattern
docker run -d \
  -v postgres-data:/var/lib/postgresql/data \
  postgres:15-alpine

# /var/lib/postgresql/data = postgres data dir
# mysql → /var/lib/mysql
# redis → /data
# mongodb → /data/db

### Always Use Volumes for Databases!
Without volume: delete container = lose ALL data
With volume: delete container = data SAFE

---

## Exercise 4: tmpfs Mounts ✅
- [x] Created tmpfs mount
- [x] Verified data in memory not disk
- [x] Understood use cases

### Proof
See: practices/day29-practice/exercise4-proof.txt

### tmpfs Command
--tmpfs /tmp:rw,noexec,nosuid,size=100m
--mount type=tmpfs,target=/path,tmpfs-size=50m

### Use Cases
- Sensitive data processing (credit cards)
- Session tokens
- Temporary high-speed computation
- Data that must NEVER touch disk

---

## Exercise 5: Volume Backup ✅
- [x] Backed up volume to tar.gz file
- [x] Restored volume from backup
- [x] Verified restored data matches original

### Proof
See: practices/day29-practice/exercise5-proof.txt
See: practices/day29-practice/backups/

### Backup Command
docker run --rm \
  -v myvolume:/data \
  -v $(pwd):/backup \
  ubuntu:22.04 \
  tar czf /backup/backup.tar.gz -C /data .

### Restore Command
docker run --rm \
  -v myvolume:/data \
  -v $(pwd):/backup \
  ubuntu:22.04 \
  tar xzf /backup/backup.tar.gz -C /data

### Production Backup Schedule
cron: 0 2 * * * docker run --rm -v prod-db:/data ...
Store backups in: S3, GCS, Azure Blob

---

## Exercise 6: --mount Syntax ✅
- [x] Used --mount type=volume
- [x] Used --mount type=bind,readonly
- [x] Used --mount type=tmpfs
- [x] Compared -v vs --mount syntax

### Proof
See: practices/day29-practice/exercise6-proof.txt

### --mount vs -v
-v = shorter, widely used, still valid
--mount = explicit, better error messages
         recommended in new scripts

### Examples
-v myvolume:/data
= --mount type=volume,source=myvolume,target=/data

-v /host/path:/container/path:ro
= --mount type=bind,source=/host/path,target=/container/path,readonly

---

## Volume Best Practices Summary

### Database Volumes
/var/lib/postgresql/data  → postgres
/var/lib/mysql             → mysql
/data                      → redis, mongodb
Always named volumes for databases!

### Development Workflow
-v $(pwd):/app = live code editing
No rebuild needed for code changes
Use with -w /app to set working dir

### Security
:ro = read-only for config, certs, keys
tmpfs for sensitive temp data
Never mount sensitive host dirs (/)

### Backup Strategy
Daily cron backup volumes to tar.gz
Test restores regularly
Store backups off-server (S3 etc)

---

## Summary
All 6 exercises completed on Jul 17 2026

Scripts written:
- volumes-reference.sh
- volume-demo.sh

Proof files:
- exercise1-proof.txt (named volumes)
- exercise2-proof.txt (bind mounts)
- exercise3-proof.txt (database persistence)
- exercise4-proof.txt (tmpfs)
- exercise5-proof.txt (backup/restore)
- exercise6-proof.txt (--mount syntax)
- script-output-volumes.txt
- script-output-demo.txt

Key concepts mastered:
- WHY data persistence matters
- Three storage types (volume/bind/tmpfs)
- Named volume CRUD operations
- Bind mount for development workflow
- Database volume patterns (postgres mysql redis)
- Volume backup and restore
- --mount syntax
- Volume security best practices
