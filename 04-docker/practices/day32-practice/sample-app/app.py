#!/usr/bin/env python3
"""
DevOps Registry Demo App
Author: Asim Raza - Day 32
Shows: version, registry, build info
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
import socket
from datetime import datetime


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.respond(200, {
                "service": "registry-demo",
                "version": os.getenv("APP_VERSION", "1.0.0"),
                "build_date": os.getenv("BUILD_DATE", "unknown"),
                "git_commit": os.getenv("GIT_COMMIT", "unknown"),
                "hostname": socket.gethostname(),
                "registry": os.getenv("REGISTRY", "local"),
                "message": "Image successfully pulled from registry!"
            })
        elif self.path == '/health':
            self.respond(200, {
                "status": "healthy",
                "timestamp": datetime.utcnow().isoformat()
            })
        else:
            self.respond(404, {"error": "Not found"})

    def respond(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(
            f"[{datetime.utcnow().isoformat()}] {fmt % args}",
            flush=True
        )


if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))
    print(f"Registry demo starting on :{port}", flush=True)
    HTTPServer(('0.0.0.0', port), Handler).serve_forever()
