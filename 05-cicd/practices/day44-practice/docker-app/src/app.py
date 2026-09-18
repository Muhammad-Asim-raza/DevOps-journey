#!/usr/bin/env python3
"""
CI/CD Docker Demo App
Author: Asim Raza - Day 44
Demonstrates: Docker build in GitHub Actions
"""
import json
import os
import sys
import time
from datetime import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler


BUILD_INFO = {
    "version":    os.getenv("APP_VERSION", "dev"),
    "commit":     os.getenv("GIT_COMMIT",  "local"),
    "build_time": os.getenv("BUILD_TIME",  "unknown"),
    "branch":     os.getenv("GIT_BRANCH",  "local"),
}

START_TIME = time.time()


class AppHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        routes = {
            "/":        self._home,
            "/health":  self._health,
            "/version": self._version,
            "/ready":   self._ready,
        }
        handler = routes.get(self.path)
        if handler:
            handler()
        else:
            self._json(404, {"error": "not found"})

    def _home(self):
        self._json(200, {
            "service": "cicd-docker-demo",
            "message": "Docker CI/CD Pipeline - Day 44",
            "author":  "Asim Raza",
            "uptime":  round(time.time() - START_TIME, 1),
            "build":   BUILD_INFO,
        })

    def _health(self):
        self._json(200, {
            "status":    "healthy",
            "timestamp": datetime.utcnow().isoformat(),
            "version":   BUILD_INFO["version"],
        })

    def _version(self):
        self._json(200, BUILD_INFO)

    def _ready(self):
        self._json(200, {
            "status":  "ready",
            "version": BUILD_INFO["version"],
        })

    def _json(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header("Content-Type",   "application/json")
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(
            json.dumps({
                "time":    datetime.utcnow().isoformat(),
                "level":   "INFO",
                "message": fmt % args,
            }),
            flush=True,
        )


if __name__ == "__main__":
    port = int(os.getenv("PORT", "8000"))
    print(json.dumps({
        "time":    datetime.utcnow().isoformat(),
        "level":   "INFO",
        "message": f"Starting on :{port}",
        "build":   BUILD_INFO,
    }), flush=True)
    HTTPServer(("0.0.0.0", port), AppHandler).serve_forever()
