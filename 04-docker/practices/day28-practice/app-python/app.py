#!/usr/bin/env python3
"""
Simple DevOps Web App
Author: Asim Raza - Day 28
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
from datetime import datetime


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.respond(200, {
                "status": "healthy",
                "timestamp": datetime.utcnow().isoformat(),
                "version": os.getenv("APP_VERSION", "1.0.0"),
                "environment": os.getenv("APP_ENV", "production")
            })
        elif self.path == '/':
            self.respond(200, {
                "message": "DevOps App Running in Docker!",
                "author": "Asim Raza",
                "day": "Day 28 - Dockerfile Mastery",
                "container_id": os.uname().nodename
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

    def log_message(self, format, *args):
        print(f"[{datetime.utcnow().isoformat()}] {format % args}")


if __name__ == '__main__':
    PORT = int(os.getenv("PORT", 8000))
    print(f"Starting server on port {PORT}")
    server = HTTPServer(('0.0.0.0', PORT), Handler)
    server.serve_forever()
# A comment
