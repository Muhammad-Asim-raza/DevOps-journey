# 🐳 DevOps Platform

> Production-grade containerized platform — Docker Phase Project (Day 38)

**Author:** Asim Raza  
**Version:** 1.0.0

---

## 🏗️ Architecture

Internet → nginx:8600 → api:5000 → postgres:5432
↓
redis:6379

Monitoring:
cadvisor → prometheus:8601 → grafana:8602


## 📦 Services

| Service    | Image              | Purpose           |
|------------|--------------------|-------------------|
| nginx      | nginx:1.25-alpine  | Reverse proxy     |
| api        | custom (Day 28)    | Python REST API   |
| postgres   | postgres:15-alpine | Database          |
| redis      | redis:7-alpine     | Cache             |
| cadvisor   | cadvisor:v0.47.2   | Container metrics |
| prometheus | prom:v2.48.0       | Metrics database  |
| grafana    | grafana:10.2.0     | Dashboards        |

## 🚀 Quick Start

```bash
cp .env.example .env
# Edit .env with your passwords
bash scripts/deploy.sh
```

## 🔗 Access Points

| Service    | URL                       | Credentials      |
|------------|---------------------------|------------------|
| API        | http://localhost:8600     | -                |
| Prometheus | http://localhost:8601     | -                |
| Grafana    | http://localhost:8602     | admin/DevOps2026!|

## 🏥 API Endpoints

| Endpoint   | Purpose                    |
|------------|----------------------------|
| /          | Service info               |
| /health    | Liveness check             |
| /ready     | Readiness check            |
| /live      | Liveness probe             |
| /metrics   | Prometheus metrics         |
| /status    | Runtime status             |
| /info      | Configuration info         |

## 🔒 Security Features

- ✅ Non-root user (UID 1001)
- ✅ Read-only filesystem
- ✅ No secrets in image
- ✅ Network isolation (3 networks)
- ✅ Resource limits (memory + CPU)
- ✅ Security headers (nginx)
- ✅ Rate limiting (nginx)

## 📊 Docker Phase Skills Demonstrated

| Day | Skill | Where Used |
|-----|-------|------------|
| 28  | Multi-stage Dockerfile | api/Dockerfile |
| 29  | Named volumes | postgres-data, redis-data |
| 30  | Custom networks | frontend/backend/monitoring |
| 31  | Docker Compose | docker-compose.yml |
| 33  | Security hardening | read_only, non-root |
| 34  | Build optimization | multi-stage, non-root |
| 35  | Production patterns | health checks, graceful stop |
| 36  | Monitoring stack | Prometheus + Grafana |
