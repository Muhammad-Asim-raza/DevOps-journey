#!/usr/bin/env python3
"""
Production App with Health Check Patterns
Author: Asim Raza - Day 35
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
import time
import threading
from datetime import datetime

# Simulate startup time
START_TIME = time.time()
STARTUP_DURATION = float(os.getenv('STARTUP_SECONDS', '3'))

# Simulated service states
services_ready = {
    "database": False,
    "cache": False,
    "app": True
}

def simulate_startup():
    """Simulate services coming online gradually"""
    time.sleep(1)
    services_ready["database"] = True
    time.sleep(1)
    services_ready["cache"] = True
    print("All services ready!", flush=True)

# Start background initialization
threading.Thread(
    target=simulate_startup,
    daemon=True
).start()


class HealthHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        routes = {
            '/health':   self.health,
            '/ready':    self.readiness,
            '/live':     self.liveness,
            '/startup':  self.startup,
            '/':         self.home,
            '/fail':     self.fail,
        }
        handler = routes.get(self.path)
        if handler:
            handler()
        else:
            self.json_response(404, {"error": "not found"})

    def home(self):
        uptime = time.time() - START_TIME
        self.json_response(200, {
            "service": "health-demo",
            "uptime_seconds": round(uptime, 1),
            "services": services_ready,
            "all_ready": all(services_ready.values())
        })

    def health(self):
        """
        Basic health check - is the process alive?
        Used by Docker HEALTHCHECK
        Simple: return 200 if process running
        """
        self.json_response(200, {
            "status": "healthy",
            "timestamp": datetime.utcnow().isoformat()
        })

    def readiness(self):
        """
        Readiness check - is app ready for TRAFFIC?
        Used by Kubernetes readinessProbe
        Only returns 200 when ALL dependencies ready
        """
        all_ready = all(services_ready.values())

        if all_ready:
            self.json_response(200, {
                "status": "ready",
                "services": services_ready,
                "message": "Ready to receive traffic"
            })
        else:
            not_ready = [
                k for k, v in services_ready.items()
                if not v
            ]
            self.json_response(503, {
                "status": "not_ready",
                "waiting_for": not_ready,
                "message": "Service initializing"
            })

    def liveness(self):
        """
        Liveness check - is app in a good state?
        Used by Kubernetes livenessProbe
        Returns 503 if app is in broken state
        (should be restarted by orchestrator)
        """
        uptime = time.time() - START_TIME

        # Example: unhealthy if running too long
        # without a restart (memory leak simulation)
        if uptime > 86400:  # 24 hours
            self.json_response(503, {
                "status": "unhealthy",
                "reason": "Needs restart (uptime > 24h)"
            })
        else:
            self.json_response(200, {
                "status": "alive",
                "uptime_seconds": round(uptime, 1)
            })

    def startup(self):
        """
        Startup check - has app finished starting?
        Used by Kubernetes startupProbe
        Prevents liveness from killing slow starters
        """
        all_ready = all(services_ready.values())
        if all_ready:
            self.json_response(200, {
                "status": "started",
                "services": services_ready
            })
        else:
            self.json_response(503, {
                "status": "starting",
                "services": services_ready
            })

    def fail(self):
        """Simulate unhealthy endpoint for testing"""
        self.json_response(503, {
            "status": "unhealthy",
            "error": "Simulated failure"
        })

    def json_response(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(
            f"[{datetime.utcnow().isoformat()}] "
            f"{self.address_string()} {fmt % args}",
            flush=True
        )


if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))
    print(f"Health demo starting on :{port}", flush=True)
    HTTPServer(('0.0.0.0', port), HealthHandler).serve_forever()
