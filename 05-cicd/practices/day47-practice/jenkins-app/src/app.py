#!/usr/bin/env python3
"""
Jenkins Pipeline Demo App
Author: Asim Raza - Day 47
"""
import json
import os
import time
from datetime import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler

BUILD_INFO = {
    "built_by":   os.getenv("BUILD_TOOL",    "jenkins"),
    "build_num":  os.getenv("BUILD_NUMBER",  "local"),
    "job_name":   os.getenv("JOB_NAME",      "local"),
    "git_commit": os.getenv("GIT_COMMIT",    "local"),
    "version":    os.getenv("APP_VERSION",   "1.0.0"),
}
START_TIME = time.time()


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        routes = {
            "/":       self._home,
            "/health": self._health,
            "/build":  self._build,
        }
        (routes.get(self.path) or self._not_found)()

    def _home(self):
        self._json(200, {
            "service": "jenkins-demo",
            "uptime":  round(time.time() - START_TIME, 1),
        })

    def _health(self):
        self._json(200, {
            "status": "healthy",
            "time":   datetime.utcnow().isoformat(),
        })

    def _build(self):
        self._json(200, BUILD_INFO)

    def _not_found(self):
        self._json(404, {"error": "not found"})

    def _json(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *a):
        pass


if __name__ == "__main__":
    port = int(os.getenv("PORT", "8000"))
    print(f"Jenkins demo app on :{port}", flush=True)
    HTTPServer(("0.0.0.0", port), Handler).serve_forever()
