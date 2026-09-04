#!/usr/bin/env python3
from http.server import HTTPServer, BaseHTTPRequestHandler
import json, os, socket

class H(BaseHTTPRequestHandler):
    def do_GET(self):
        body = json.dumps({
            "version": "2.0.0",
            "color": "green",
            "hostname": socket.gethostname(),
            "status": "OK",
            "new_feature": "enabled"
        }, indent=2).encode()
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)
    def log_message(self, *a): pass

HTTPServer(('0.0.0.0', int(os.getenv('PORT',8000))), H).serve_forever()
