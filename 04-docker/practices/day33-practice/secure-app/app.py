#!/usr/bin/env python3
"""
Security Demo App
Author: Asim Raza - Day 33
Demonstrates: non-root, read-only fs, capabilities
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
import pwd
import grp
from datetime import datetime


class SecurityHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        routes = {
            '/':        self.home,
            '/health':  self.health,
            '/whoami':  self.whoami,
            '/env':     self.env_check,
        }
        handler = routes.get(self.path)
        if handler:
            handler()
        else:
            self.json_response(404, {"error": "not found"})

    def home(self):
        self.json_response(200, {
            "service": "secure-demo",
            "message": "Running with security best practices!"
        })

    def health(self):
        self.json_response(200, {
            "status": "healthy",
            "timestamp": datetime.utcnow().isoformat()
        })

    def whoami(self):
        uid = os.getuid()
        gid = os.getgid()
        try:
            username = pwd.getpwuid(uid).pw_name
        except KeyError:
            username = str(uid)
        try:
            groupname = grp.getgrgid(gid).gr_name
        except KeyError:
            groupname = str(gid)

        self.json_response(200, {
            "uid":       uid,
            "gid":       gid,
            "username":  username,
            "group":     groupname,
            "is_root":   uid == 0,
            "secure":    uid != 0
        })

    def env_check(self):
        # Show safe env vars (no secrets)
        safe_vars = {
            k: v for k, v in os.environ.items()
            if k not in [
                'PASSWORD', 'SECRET', 'KEY',
                'TOKEN', 'PASS', 'CREDENTIAL'
            ]
        }
        self.json_response(200, {
            "safe_env_vars": list(safe_vars.keys()),
            "total_vars": len(os.environ)
        })

    def json_response(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(
            f"[{datetime.utcnow().isoformat()}] {fmt % args}",
            flush=True
        )


if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))
    print(f"Secure app starting on :{port}", flush=True)
    HTTPServer(('0.0.0.0', port), SecurityHandler).serve_forever()
