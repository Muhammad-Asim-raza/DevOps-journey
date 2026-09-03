# Day 36 Exercises — Docker Monitoring & Logging
**Date:** Jul 24 2026
**Status:** ✅ Completed

---

## Exercise 1: Built-in Docker Monitoring ✅
- [x] Used docker stats with all formats
- [x] Used docker inspect for detailed info
- [x] Formatted stats output for scripting
- [x] Monitored specific containers

### Proof
See: practices/day36-practice/exercise1-proof.txt

### Commands
docker stats --no-stream
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
docker stats --format '{{json .}}'
docker inspect --format '{{.State.Health.Status}}' container

### What docker stats Shows
NAME     = container name
CPU %    = current CPU percentage
MEM USAGE/LIMIT = memory used / limit set
MEM %    = percentage of limit
NET I/O  = network bytes in/out
BLOCK I/O = disk read/write
PIDS     = process count

---

## Exercise 2: Prometheus Monitoring Stack ✅
- [x] Built app with /metrics endpoint
- [x] Deployed cAdvisor for container metrics
- [x] Configured Prometheus with prometheus.yml
- [x] Added alert rules
- [x] Deployed Grafana with auto-provisioned datasource
- [x] Deployed Loki for log aggregation
- [x] Verified all targets in Prometheus

### Proof
See: practices/day36-practice/exercise2-proof.txt
See: practices/day36-practice/monitoring-stack/

### Stack Access Points
App:        http://localhost:8401/metrics
cAdvisor:   http://localhost:8402/metrics
Prometheus: http://localhost:8403
Grafana:    http://localhost:8404 (admin/DevOps2026!)
Loki:       http://localhost:8405

### Architecture
App → (scraped by) → Prometheus
cAdvisor → (scraped by) → Prometheus
Prometheus → (queried by) → Grafana
Loki → (queried by) → Grafana (for logs)

---

## Exercise 3: PromQL Queries ✅
- [x] Queried CPU usage rate
- [x] Queried memory usage
- [x] Queried custom app metrics
- [x] Understood rate() and histogram_quantile()

### Proof
See: practices/day36-practice/exercise3-proof.txt

### Essential PromQL
rate(metric[5m])     = per-second rate over 5 min
increase(metric[1h]) = total increase over 1 hour
histogram_quantile(0.99, ...) = 99th percentile
avg(metric) by (label)  = average grouped by label
sum(metric) without (label) = sum dropping label

### Alert Rule Pattern
- alert: HighMemory
  expr: container_memory_usage_bytes / container_spec_memory_limit_bytes > 0.85
  for: 5m
  labels:
    severity: warning

---

## Exercise 4: Docker Events ✅
- [x] Created monitor_events.sh script
- [x] Watched real-time container events
- [x] Filtered events by type
- [x] Understood all event types

### Proof
See: practices/day36-practice/exercise4-proof.txt
See: practices/day36-practice/docker-events/monitor_events.sh

### Docker Event Types
create = container created
start  = container started
stop   = graceful stop
die    = container exited
kill   = force killed
oom    = OUT OF MEMORY (critical!)
restart = restarted
health_status = health check result changed

### Use in Production
Monitor for 'die' events → alert on unexpected crashes
Monitor for 'oom' events → memory limits too low
Monitor for 'health_status: unhealthy' → app issues

---

## Monitoring Architecture Reference

### Metrics Pipeline
Containers → cAdvisor → Prometheus → Grafana

### Log Pipeline
Containers (stdout) → Loki → Grafana

### Alert Pipeline
Prometheus → Alertmanager → Slack/PagerDuty

### Key Metrics to Alert On
CPU > 80% for 5 minutes
Memory > 85% of limit
Container restarts > 3 in 15 minutes
Error rate > 5% of requests
Health check unhealthy
Container 'oom' event

---

## Summary
All 4 exercises completed on Jul 24 2026

Scripts written:
- monitoring-reference.sh
- docker-events/monitor_events.sh

Applications built:
- metrics-app (Prometheus metrics endpoint)

Monitoring stack deployed:
- cAdvisor (container metrics)
- Prometheus (metrics database + alerts)
- Grafana (dashboards)
- Loki (log aggregation)

Proof files:
- exercise1-proof.txt (docker stats)
- exercise2-proof.txt (Prometheus stack)
- exercise3-proof.txt (PromQL)
- exercise4-proof.txt (docker events)
- script-output-monitoring.txt

Key concepts mastered:
- Three pillars of observability
- docker stats and docker events
- Prometheus scraping architecture
- cAdvisor container metrics
- PromQL query language
- Alert rules
- Grafana provisioning
- Loki log aggregation
- Docker events monitoring
