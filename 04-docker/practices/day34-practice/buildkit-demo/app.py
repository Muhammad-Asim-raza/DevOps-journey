#!/usr/bin/env python3
from http.server import HTTPServer, BaseHTTPRequestHandler
import json, os

class H(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps({
            "service": "buildkit-demo",
            "cache": "mount enabled"
        }).encode())
    def log_message(self, *a): pass

if __name__ == '__main__':
    HTTPServer(('0.0.0.0', int(os.getenv('PORT',8000))), H).serve_forever()
