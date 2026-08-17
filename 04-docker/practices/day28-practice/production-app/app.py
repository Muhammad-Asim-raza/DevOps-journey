#!/usr/bin/env python3
"""
Production-Ready DevOps App
Author: Asim Raza - Day 28
Demonstrates: ARG, LABEL, HEALTHCHECK, USER
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
import sys
from datetime import datetime


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        routes = {
            '/': self.home,
            '/health': self.health,
            '/info': self.info,
            '/ready': self.ready,
        }
        handler = routes.get(self.path)
        if handler:
            handler()
        else:
            self.send_json(404, {"error": "Not found"})

    def home(self):
        self.send_json(200, {
            "service": "devops-production-app",
            "status": "running",
            "hostname": os.uname().nodename
        })

    def health(self):
        self.send_json(200, {
            "status": "healthy",
            "timestamp": datetime.utcnow().isoformat()
        })

    def ready(self):
        # Readiness probe - is app ready for traffic?
        self.send_json(200, {"ready": True})

    def info(self):
        self.send_json(200, {
            "version": os.getenv("APP_VERSION", "unknown"),
            "build_date": os.getenv("BUILD_DATE", "unknown"),
            "git_commit": os.getenv("GIT_COMMIT", "unknown"),
            "environment": os.getenv("APP_ENV", "production")
        })

    def send_json(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format, *args):
        print(f"[{datetime.utcnow().isoformat()}] {format % args}",
              flush=True)


if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))
    print(f"[INFO] Starting production server on :{port}",
          flush=True)
    server = HTTPServer(('0.0.0.0', port), Handler)
    server.serve_forever()
