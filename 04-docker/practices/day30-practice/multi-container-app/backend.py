#!/usr/bin/env python3
"""
Backend API Service
Demonstrates container-to-container networking
Author: Asim Raza - Day 30
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
import socket
from datetime import datetime


class BackendHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.json_response(200, {
                "service": "backend-api",
                "status": "healthy",
                "hostname": socket.gethostname(),
                "timestamp": datetime.utcnow().isoformat()
            })
        elif self.path == '/data':
            # In real app: query database here
            # db_host = os.getenv('DB_HOST', 'database')
            self.json_response(200, {
                "data": [
                    {"id": 1, "name": "DevOps"},
                    {"id": 2, "name": "Docker"},
                    {"id": 3, "name": "Networking"}
                ],
                "source": "backend-api",
                "db_host": os.getenv("DB_HOST", "database")
            })
        else:
            self.json_response(404, {"error": "Not found"})

    def json_response(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(f"[{datetime.utcnow().isoformat()}] {fmt % args}",
              flush=True)


if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    print(f"Backend API starting on port {port}", flush=True)
    HTTPServer(('0.0.0.0', port), BackendHandler).serve_forever()
