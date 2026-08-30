#!/usr/bin/env python3
"""
Production Python App - Optimization Demo
Author: Asim Raza - Day 34
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
import sys
from datetime import datetime


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.respond(200, {"status": "healthy"})
        elif self.path == '/':
            self.respond(200, {
                "service": "python-optimized",
                "python": sys.version,
                "stage": os.getenv("BUILD_STAGE", "unknown"),
                "timestamp": datetime.utcnow().isoformat()
            })
        else:
            self.respond(404, {"error": "not found"})

    def respond(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args): pass


if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))
    print(f"Starting on :{port}", flush=True)
    HTTPServer(('0.0.0.0', port), Handler).serve_forever()
