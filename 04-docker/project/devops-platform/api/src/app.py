#!/usr/bin/env python3
"""
DevOps Platform API
Author: Asim Raza - Day 38 Docker Phase Project
Production-grade Python API with:
  - Health/readiness/liveness endpoints
  - Prometheus metrics
  - Structured JSON logging
  - Database + cache integration
  - Graceful shutdown
"""
import json
import logging
import os
import signal
import sys
import threading
import time
from datetime import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler

# ── Structured JSON Logger ──
class JSONFormatter(logging.Formatter):
    def format(self, record):
        return json.dumps({
            "timestamp": datetime.utcnow().isoformat(),
            "level":     record.levelname,
            "message":   record.getMessage(),
            "service":   "devops-platform-api",
            "version":   os.getenv("APP_VERSION", "1.0.0"),
        })

handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(JSONFormatter())
logger = logging.getLogger("api")
logger.setLevel(logging.INFO)
logger.addHandler(handler)
logger.propagate = False

# ── Metrics ──
metrics = {
    "requests_total":  0,
    "errors_total":    0,
    "start_time":      time.time(),
}
metrics_lock = threading.Lock()

# ── Graceful shutdown ──
shutdown_event = threading.Event()

def handle_sigterm(signum, frame):
    logger.info("SIGTERM received - graceful shutdown starting")
    shutdown_event.set()
    sys.exit(0)

signal.signal(signal.SIGTERM, handle_sigterm)
signal.signal(signal.SIGINT,  handle_sigterm)


def check_redis():
    """Check Redis connectivity"""
    try:
        import socket
        host = os.getenv("REDIS_HOST", "redis")
        port = int(os.getenv("REDIS_PORT", "6379"))
        s = socket.socket()
        s.settimeout(2)
        s.connect((host, port))
        s.close()
        return True
    except Exception:
        return False


def check_postgres():
    """Check PostgreSQL connectivity"""
    try:
        import socket
        host = os.getenv("DB_HOST", "postgres")
        port = int(os.getenv("DB_PORT", "5432"))
        s = socket.socket()
        s.settimeout(2)
        s.connect((host, port))
        s.close()
        return True
    except Exception:
        return False


class APIHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        with metrics_lock:
            metrics["requests_total"] += 1

        routes = {
            "/":        self.home,
            "/health":  self.health,
            "/ready":   self.ready,
            "/live":    self.live,
            "/metrics": self.prometheus_metrics,
            "/info":    self.info,
            "/status":  self.status,
        }
        handler = routes.get(self.path)
        if handler:
            handler()
        else:
            self.json_response(404, {
                "error": "not found",
                "path":  self.path
            })

    def home(self):
        self.json_response(200, {
            "service":  "devops-platform-api",
            "version":  os.getenv("APP_VERSION", "1.0.0"),
            "message":  "Docker Phase Project - Day 38",
            "author":   "Asim Raza",
            "uptime_s": round(
                time.time() - metrics["start_time"], 1
            ),
        })

    def health(self):
        """Basic liveness - is process alive?"""
        if shutdown_event.is_set():
            self.json_response(503, {
                "status": "shutting_down"
            })
            return
        self.json_response(200, {
            "status":    "healthy",
            "timestamp": datetime.utcnow().isoformat(),
        })

    def ready(self):
        """Readiness - are dependencies available?"""
        redis_ok    = check_redis()
        postgres_ok = check_postgres()
        all_ok      = redis_ok and postgres_ok

        self.json_response(
            200 if all_ok else 503,
            {
                "status":   "ready" if all_ok else "not_ready",
                "redis":    "up" if redis_ok    else "down",
                "postgres": "up" if postgres_ok else "down",
            }
        )

    def live(self):
        """Liveness - not stuck/deadlocked?"""
        uptime = time.time() - metrics["start_time"]
        self.json_response(200, {
            "status":   "alive",
            "uptime_s": round(uptime, 1),
        })

    def prometheus_metrics(self):
        """Expose Prometheus-format metrics"""
        uptime = time.time() - metrics["start_time"]
        body = (
            "# HELP api_requests_total Total HTTP requests\n"
            "# TYPE api_requests_total counter\n"
            f"api_requests_total {metrics['requests_total']}\n"
            "# HELP api_errors_total Total errors\n"
            "# TYPE api_errors_total counter\n"
            f"api_errors_total {metrics['errors_total']}\n"
            "# HELP api_uptime_seconds Uptime in seconds\n"
            "# TYPE api_uptime_seconds gauge\n"
            f"api_uptime_seconds {uptime:.2f}\n"
        ).encode()
        self.send_response(200)
        self.send_header(
            "Content-Type",
            "text/plain; version=0.0.4"
        )
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def info(self):
        self.json_response(200, {
            "app_env":      os.getenv("APP_ENV",     "production"),
            "app_version":  os.getenv("APP_VERSION", "1.0.0"),
            "db_host":      os.getenv("DB_HOST",     "postgres"),
            "redis_host":   os.getenv("REDIS_HOST",  "redis"),
            "log_level":    os.getenv("LOG_LEVEL",   "INFO"),
        })

    def status(self):
        self.json_response(200, {
            "requests_total": metrics["requests_total"],
            "errors_total":   metrics["errors_total"],
            "uptime_s":       round(
                time.time() - metrics["start_time"], 1
            ),
            "redis_connected":    check_redis(),
            "postgres_connected": check_postgres(),
        })

    def json_response(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        logger.info(
            f"{self.address_string()} {fmt % args}"
        )


if __name__ == "__main__":
    port = int(os.getenv("PORT", "5000"))
    logger.info(f"API starting on :{port}")
    HTTPServer(("0.0.0.0", port), APIHandler).serve_forever()
