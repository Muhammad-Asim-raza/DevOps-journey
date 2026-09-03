#!/bin/bash
# ================================================
# monitoring-reference.sh
# Docker Monitoring Complete Reference
# Author: Asim Raza
# Day 36 of DevOps Journey
# ================================================

echo "============================================"
echo "   DOCKER MONITORING REFERENCE"
echo "   Author: Asim Raza - Day 36"
echo "============================================"

echo ""
echo "[ THREE PILLARS OF OBSERVABILITY ]"
echo "  Metrics  = numbers over time (WHAT)"
echo "    CPU, memory, request rate, error rate"
echo "    Tool: Prometheus + Grafana"
echo ""
echo "  Logs     = events with context (WHY)"
echo "    Errors, warnings, user actions"
echo "    Tool: Loki + Grafana"
echo ""
echo "  Traces   = request flow (WHERE)"
echo "    Which service is slow?"
echo "    Tool: Jaeger, Zipkin, AWS X-Ray"

echo ""
echo "[ BUILT-IN DOCKER MONITORING ]"
echo "  docker stats                     = live all containers"
echo "  docker stats --no-stream         = snapshot"
echo "  docker stats CONTAINER           = specific container"
echo "  docker stats --format ...        = custom format"
echo "  docker inspect CONTAINER         = full container info"
echo "  docker logs -f CONTAINER         = follow logs"
echo "  docker events                    = real-time events"
echo "  docker events --since 1h         = last hour"
echo "  docker events --filter type=container"

echo ""
echo "[ PROMETHEUS STACK ]"
echo "  cAdvisor:   container metrics exporter"
echo "  Prometheus: time-series database + scraper"
echo "  Grafana:    visualization dashboards"
echo "  Loki:       log aggregation"
echo "  Promtail:   log shipper to Loki"
echo "  AlertMgr:   alert routing"

echo ""
echo "[ KEY PROMQL QUERIES ]"
cat << 'EOF'
  # CPU usage %:
  rate(container_cpu_usage_seconds_total[5m]) * 100

  # Memory usage MB:
  container_memory_usage_bytes / 1024 / 1024

  # Memory % of limit:
  (container_memory_usage_bytes /
   container_spec_memory_limit_bytes) * 100

  # Network RX rate:
  rate(container_network_receive_bytes_total[5m])

  # Container restarts in 1h:
  changes(container_start_time_seconds[1h])

  # Is container up?
  up

  # HTTP error rate:
  rate(http_errors_total[5m]) /
  rate(http_requests_total[5m])

  # Request latency p99:
  histogram_quantile(0.99,
    rate(http_request_duration_seconds_bucket[5m]))
EOF

echo ""
echo "[ ALERT RULE PATTERN ]"
cat << 'EOF'
  - alert: ContainerDown
    expr: up == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      summary: "Container down: {{ $labels.job }}"
EOF

echo ""
echo "[ LOG MONITORING ]"
echo "  Structured JSON logs = machine parseable"
echo "  Log levels: DEBUG INFO WARNING ERROR CRITICAL"
echo "  Send to Loki via Promtail or log driver"
echo ""
echo "  Loki log driver for Docker:"
echo "  docker run \\"
echo "    --log-driver loki \\"
echo "    --log-opt loki-url=http://localhost:3100/loki/api/v1/push \\"
echo "    myapp:v1.0"

echo ""
echo "[ DOCKER EVENTS ]"
echo "  docker events                     = live stream"
echo "  docker events --since 30m         = last 30 min"
echo "  docker events --filter event=die  = crashes only"
echo "  docker events --filter type=container"
echo "  docker events --format '{{json .}}' = JSON output"

echo ""
echo "[ CURRENT MONITORING STACK STATUS ]"
docker compose -f \
    04-docker/practices/day36-practice/monitoring-stack/docker-compose.yml \
    ps 2>/dev/null | head -10 || \
    echo "  Run: cd monitoring-stack && docker compose ps"

echo ""
echo "[ MONITORING STACK URLS ]"
echo "  App:        http://localhost:8401"
echo "  cAdvisor:   http://localhost:8402"
echo "  Prometheus: http://localhost:8403"
echo "  Grafana:    http://localhost:8404"
echo "  Loki:       http://localhost:8405"

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
