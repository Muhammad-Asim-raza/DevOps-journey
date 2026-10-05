#!/usr/bin/env python3
"""
DevOps CI/CD Platform - Phase 5 Project
Author: Asim Raza - Day 52
Production-grade API demonstrating complete CI/CD pipeline
"""
import json
import os
import signal
import sys
import time
import threading
from datetime import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler


# ── Build metadata injected by CI/CD ──────────────
BUILD = {
    "version":     os.getenv("APP_VERSION",   "dev"),
    "commit":      os.getenv("GIT_COMMIT",    "local")[:7],
    "branch":      os.getenv("GIT_BRANCH",    "local"),
    "build_num":   os.getenv("BUILD_NUMBER",  "0"),
    "built_by":    os.getenv("BUILD_TOOL",    "local"),
    "pipeline_id": os.getenv("CI_PIPELINE_ID","local"),
    "registry":    os.getenv("REGISTRY",      "ghcr.io"),
}

START_TIME  = time.time()
SHUTDOWN    = threading.Event()
active_reqs = 0
req_lock    = threading.Lock()

# ── Metrics ───────────────────────────────────────
metrics = {
    "requests_total": 0,
    "errors_total":   0,
    "start_time":     START_TIME,
}


class PlatformHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        global active_reqs
        with req_lock:
            active_reqs += 1
            metrics["requests_total"] += 1
        try:
            self._dispatch()
        except Exception as e:
            metrics["errors_total"] += 1
            self._json(500, {"error": str(e)})
        finally:
            with req_lock:
                active_reqs -= 1

    def _dispatch(self):
        routes = {
            "/":         self._home,
            "/health":   self._health,
            "/ready":    self._ready,
            "/live":     self._live,
            "/metrics":  self._metrics,
            "/build":    self._build_info,
            "/status":   self._status,
        }
        handler = routes.get(self.path)
        if handler:
            handler()
        else:
            self._json(404, {
                "error":    "not found",
                "path":     self.path,
                "endpoints": list(routes.keys()),
            })

    def _home(self):
        self._json(200, {
            "service":  "devops-cicd-platform",
            "message":  "Phase 5 CI/CD Project Complete!",
            "author":   "Asim Raza",
            "day":      "52 of 120",
            "uptime_s": round(time.time() - START_TIME, 1),
            "build":    BUILD,
        })

    def _health(self):
        """Docker/K8s health check"""
        if SHUTDOWN.is_set():
            self._json(503, {"status": "shutting_down"})
            return
        self._json(200, {
            "status":    "healthy",
            "timestamp": datetime.utcnow().isoformat(),
            "version":   BUILD["version"],
        })

    def _ready(self):
        """Kubernetes readiness probe"""
        self._json(200, {
            "status":        "ready",
            "active_requests": active_reqs,
        })

    def _live(self):
        """Kubernetes liveness probe"""
        self._json(200, {
            "status":   "alive",
            "uptime_s": round(time.time() - START_TIME, 1),
        })

    def _metrics(self):
        """Prometheus-format metrics"""
        uptime = time.time() - START_TIME
        body = (
            "# HELP requests_total Total HTTP requests\n"
            "# TYPE requests_total counter\n"
            f"requests_total {metrics['requests_total']}\n"
            "# HELP errors_total Total errors\n"
            "# TYPE errors_total counter\n"
            f"errors_total {metrics['errors_total']}\n"
            "# HELP uptime_seconds Service uptime\n"
            "# TYPE uptime_seconds gauge\n"
            f"uptime_seconds {uptime:.2f}\n"
        ).encode()
        self.send_response(200)
        self.send_header(
            "Content-Type", "text/plain; version=0.0.4"
        )
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)
        return

    def _build_info(self):
        self._json(200, BUILD)

    def _status(self):
        self._json(200, {
            "requests_total": metrics["requests_total"],
            "errors_total":   metrics["errors_total"],
            "active_requests": active_reqs,
            "uptime_s":       round(
                time.time() - START_TIME, 1
            ),
        })

    def _json(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header("Content-Type",   "application/json")
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(json.dumps({
            "time":    datetime.utcnow().isoformat(),
            "level":   "INFO",
            "message": fmt % args,
            "service": "devops-cicd-platform",
        }), flush=True)


def handle_sigterm(sig, frame):
    print(json.dumps({
        "time":    datetime.utcnow().isoformat(),
        "level":   "INFO",
        "message": "SIGTERM received — graceful shutdown",
    }), flush=True)
    SHUTDOWN.set()
    time.sleep(2)
    sys.exit(0)


signal.signal(signal.SIGTERM, handle_sigterm)
signal.signal(signal.SIGINT,  handle_sigterm)

if __name__ == "__main__":
    port = int(os.getenv("PORT", "8000"))
    print(json.dumps({
        "time":    datetime.utcnow().isoformat(),
        "level":   "INFO",
        "message": f"Starting on :{port}",
        "build":   BUILD,
    }), flush=True)
    HTTPServer(("0.0.0.0", port), PlatformHandler).serve_forever()
