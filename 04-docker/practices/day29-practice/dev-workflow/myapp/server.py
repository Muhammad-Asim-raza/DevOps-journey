#!/usr/bin/env python3
from http.server import HTTPServer, BaseHTTPRequestHandler
import json

VERSION = "2.0.0"  # Change this to see live reload

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        response = {
            "version": VERSION,
            "message": "Edit server.py to see changes!",
            "path": self.path
        }
        self.wfile.write(json.dumps(response, indent=2).encode())
    
    def log_message(self, format, *args):
        print(f"Request: {format % args}")

if __name__ == '__main__':
    print(f"Server v{VERSION} started on port 8000")
    HTTPServer(('0.0.0.0', 8000), Handler).serve_forever()
