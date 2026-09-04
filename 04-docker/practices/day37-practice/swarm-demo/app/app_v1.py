#!/usr/bin/env python3
from http.server import HTTPServer, BaseHTTPRequestHandler
import json, os, socket

class H(BaseHTTPRequestHandler):
    def do_GET(self):
        body = json.dumps({
            "version": "1.0.0",
            "color": "blue",
            "hostname": socket.gethostname(),
            "status": "OK"
        }, indent=2).encode()
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)
    def log_message(self, *a): pass

HTTPServer(('0.0.0.0', int(os.getenv('PORT',8000))), H).serve_forever()
