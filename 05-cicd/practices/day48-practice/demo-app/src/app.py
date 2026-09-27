#!/usr/bin/env python3
"""GitLab CI Demo App - Day 48"""
import json, os, time
from datetime import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler

CI_INFO = {
    "pipeline_id":  os.getenv("CI_PIPELINE_ID",  "local"),
    "job_id":       os.getenv("CI_JOB_ID",        "local"),
    "commit_sha":   os.getenv("CI_COMMIT_SHA",    "local"),
    "branch":       os.getenv("CI_COMMIT_BRANCH", "local"),
    "project":      os.getenv("CI_PROJECT_NAME",  "local"),
    "registry":     os.getenv("CI_REGISTRY",      "registry.gitlab.com"),
}

class H(BaseHTTPRequestHandler):
    def do_GET(self):
        routes = {
            "/": lambda: {"service": "gitlab-ci-demo",
                         "uptime": round(time.time()-START, 1)},
            "/health": lambda: {"status": "healthy",
                               "time": datetime.utcnow().isoformat()},
            "/pipeline": lambda: CI_INFO,
        }
        fn = routes.get(self.path)
        code, data = (200, fn()) if fn else (404, {"error": "not found"})
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)
    def log_message(self, *a): pass

START = time.time()
if __name__ == "__main__":
    port = int(os.getenv("PORT", "8000"))
    print(f"GitLab CI demo on :{port}", flush=True)
    HTTPServer(("0.0.0.0", port), H).serve_forever()
