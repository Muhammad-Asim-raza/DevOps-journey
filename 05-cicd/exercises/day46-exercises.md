# Day 46 Exercises — Jenkins Installation & Setup
**Date:** Aug 3 2026
**Status:** ✅ Completed

---

## Exercise 1: Jenkins Installed via Docker ✅
- [x] Created docker-compose.yml for Jenkins
- [x] Started Jenkins on port 8090
- [x] Retrieved initial admin password
- [x] Jenkins accessible at http://localhost:8090

### Proof: practices/day46-practice/exercise1-proof.txt
### Config: practices/day46-practice/jenkins-config/

### Docker Compose Key Points
image: jenkins/jenkins:lts-jdk17
ports: 8090:8080 (UI), 50000:50000 (agents)
volumes:
  - jenkins-data:/var/jenkins_home (persistent)
  - /var/run/docker.sock:/var/run/docker.sock (Docker access)

### Get Initial Password
docker exec jenkins-day46 \
    cat /var/jenkins_home/secrets/initialAdminPassword

---

## Exercise 2: Plugin Reference ✅
- [x] Documented all essential plugins
- [x] Understood plugin categories
- [x] Learned install methods (UI, CLI, Dockerfile)

### Proof: practices/day46-practice/exercise2-proof.txt
### Script: jenkins-config/essential-plugins.sh

### Must-Have Plugins
Pipeline, Git, Docker Pipeline,
Credentials Binding, Blue Ocean,
JUnit, Timestamper, AnsiColor,
Workspace Cleanup, Build Timeout

---

## Exercise 3: Jenkins UI Navigation ✅
- [x] Job creation flow documented
- [x] All important URLs documented
- [x] Credentials configuration walkthrough
- [x] Global Tools configuration

### Proof: practices/day46-practice/exercise3-proof.txt
### Script: jenkins-jobs/jenkins-ui-guide.sh

### Key URLs
Dashboard:   http://localhost:8090/
Manage:      http://localhost:8090/manage
Plugins:     http://localhost:8090/pluginManager
Credentials: http://localhost:8090/credentials
Blue Ocean:  http://localhost:8090/blue
API:         http://localhost:8090/api/json

---

## Exercise 4: Security Configuration ✅
- [x] Security best practices documented
- [x] Credentials usage (right vs wrong)
- [x] Production security checklist
- [x] Backup and restore procedures

### Proof: practices/day46-practice/exercise4-proof.txt
### Script: jenkins-config/security-config.sh

---

## Jenkins Architecture Summary

### Components
Controller (Master):
  - Web UI (port 8080)
  - Job scheduler
  - Plugin manager
  - Credentials store
  - Build history

Agents (Workers):
  - Execute pipeline steps
  - Connect on port 50000
  - Linux, Windows, Docker, Kubernetes

### Job Types
Freestyle:             click UI (avoid)
Pipeline:              Jenkinsfile (best)
Multibranch Pipeline:  auto-creates per branch
Organization Folder:   scan GitHub org

### Jenkins vs GitHub Actions
Self-hosted vs Cloud
Groovy vs YAML
Complete control vs Easy setup
Legacy enterprise vs Cloud-native

---

## Summary
All 4 exercises completed Aug 3 2026

Scripts:
- jenkins-config/setup-jenkins.sh
- jenkins-config/essential-plugins.sh
- jenkins-config/security-config.sh
- jenkins-jobs/jenkins-ui-guide.sh
- jenkins-reference.sh

Files created:
- docker-compose.yml (Jenkins setup)
- first-pipeline-config.xml (job config)

Key concepts mastered:
- WHY Jenkins matters in enterprise
- Jenkins architecture (controller + agents)
- Docker-based Jenkins installation
- Plugin ecosystem (1800+)
- Essential plugins for DevOps
- Credentials management
- Security configuration
- Production best practices
- Job types and triggers
