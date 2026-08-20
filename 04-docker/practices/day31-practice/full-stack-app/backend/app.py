#!/usr/bin/env python3
"""
Full Stack Backend API
Author: Asim Raza - Day 31
Docker Compose multi-service demo
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
import socket
from datetime import datetime


VISIT_KEY = "visit_count"


def get_redis():
    """Connect to Redis"""
    try:
        import redis
        r = redis.Redis(
            host=os.getenv('REDIS_HOST', 'redis'),
            port=int(os.getenv('REDIS_PORT', 6379)),
            decode_responses=True
        )
        r.ping()
        return r
    except Exception:
        return None


class APIHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        routes = {
            '/':        self.home,
            '/health':  self.health,
            '/visits':  self.visits,
            '/config':  self.config,
        }
        handler = routes.get(self.path)
        if handler:
            handler()
        else:
            self.json_response(404, {"error": "Not found"})

    def home(self):
        self.json_response(200, {
            "service": "backend-api",
            "version": os.getenv("APP_VERSION", "1.0.0"),
            "hostname": socket.gethostname(),
            "message": "Full Stack App via Docker Compose!"
        })

    def health(self):
        redis_ok = get_redis() is not None
        self.json_response(200, {
            "status": "healthy",
            "redis": "connected" if redis_ok else "unavailable",
            "timestamp": datetime.utcnow().isoformat()
        })

    def visits(self):
        r = get_redis()
        if r:
            count = r.incr(VISIT_KEY)
            self.json_response(200, {
                "total_visits": int(count),
                "message": "Tracked in Redis!"
            })
        else:
            self.json_response(503, {"error": "Redis unavailable"})

    def config(self):
        self.json_response(200, {
            "app_env":    os.getenv("APP_ENV", "production"),
            "db_host":    os.getenv("DB_HOST", "not set"),
            "redis_host": os.getenv("REDIS_HOST", "redis"),
            "port":       os.getenv("PORT", "5000")
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
    port = int(os.getenv('PORT', 5000))
    print(f"Backend starting on :{port}", flush=True)
    HTTPServer(('0.0.0.0', port), APIHandler).serve_forever()
