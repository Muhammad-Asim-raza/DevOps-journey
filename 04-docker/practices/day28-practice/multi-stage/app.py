#!/usr/bin/env python3
"""
Production Python app - Multi-stage build demo
Author: Asim Raza - Day 28
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_json(200, {"status": "healthy"})
        elif self.path == '/':
            self.send_json(200, {
                "app": "Multi-Stage Build Demo",
                "stage": "production",
                "image": "optimized"
            })
        else:
            self.send_json(404, {"error": "Not found"})

    def send_json(self, code, data):
        body = json.dumps(data).encode()
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass


if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8000), Handler)
    print("Production server started on port 8000")
    server.serve_forever()
