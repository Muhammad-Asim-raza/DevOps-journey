#!/usr/bin/env python3
"""
Backend App 3
Simulates a real web application
Part of DevOps Journey Networking Project
Author: Asim Raza - Day 18
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
from datetime import datetime

class AppHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            response = {
                "status": "healthy",
                "app": "App-3",
                "port": 3003,
                "timestamp": datetime.now().isoformat()
            }
            self.wfile.write(json.dumps(response).encode())

        elif self.path == '/' or self.path == '/api':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            response = {
                "message": "Hello from App 3!",
                "server": "App-3",
                "port": 3003,
                "path": self.path,
                "timestamp": datetime.now().isoformat(),
                "client": self.client_address[0]
            }
            self.wfile.write(json.dumps(response).encode())

        elif self.path == '/info':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            response = {
                "app": "App-3",
                "version": "1.0.0",
                "description": "Backend service 3",
                "endpoints": ["/", "/health", "/info", "/api"]
            }
            self.wfile.write(json.dumps(response).encode())

        else:
            self.send_response(404)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            response = {"error": "Not found", "path": self.path}
            self.wfile.write(json.dumps(response).encode())

    def log_message(self, format, *args):
        print(f"[App-3] {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - {format % args}")

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 3003), AppHandler)
    print(f"[App-3] Starting on port 3003...")
    server.serve_forever()
