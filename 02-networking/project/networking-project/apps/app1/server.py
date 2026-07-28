#!/usr/bin/env python3
"""
Backend App 1
Simulates a real web application
Part of DevOps Journey Networking Project
Author: Asim Raza - Day 18
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
from datetime import datetime

class AppHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        # Health check endpoint
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            response = {
                "status": "healthy",
                "app": "App-1",
                "port": 3001,
                "timestamp": datetime.now().isoformat()
            }
            self.wfile.write(json.dumps(response).encode())

        # Main endpoint
        elif self.path == '/' or self.path == '/api':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            response = {
                "message": "Hello from App 1!",
                "server": "App-1",
                "port": 3001,
                "path": self.path,
                "timestamp": datetime.now().isoformat(),
                "client": self.client_address[0]
            }
            self.wfile.write(json.dumps(response).encode())

        # Info endpoint
        elif self.path == '/info':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            response = {
                "app": "App-1",
                "version": "1.0.0",
                "description": "Backend service 1",
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
        # Custom log format
        print(f"[App-1] {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - {format % args}")

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 3001), AppHandler)
    print(f"[App-1] Starting on port 3001...")
    print(f"[App-1] Endpoints: / /health /info /api")
    server.serve_forever()
