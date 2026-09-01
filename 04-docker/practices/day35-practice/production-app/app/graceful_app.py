#!/usr/bin/env python3
"""
Production App with Graceful Shutdown
Author: Asim Raza - Day 35

This demonstrates proper SIGTERM handling
for zero-downtime deployments
"""
import signal
import threading
import time
import json
import os
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime

# Graceful shutdown state
shutdown_event = threading.Event()
active_requests = 0
requests_lock = threading.Lock()

class GracefulHTTPServer(HTTPServer):
    """HTTP server with graceful shutdown support"""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.shutdown_requested = False

    def serve_until_shutdown(self):
        """Serve requests until shutdown requested"""
        while not shutdown_event.is_set():
            self.handle_request()


class Handler(BaseHTTPRequestHandler):

    def do_GET(self):
        global active_requests

        # Track active requests
        with requests_lock:
            active_requests += 1

        try:
            if self.path == '/health':
                # If shutting down: report unhealthy
                # Load balancer will stop routing here
                if shutdown_event.is_set():
                    self.json_response(503, {
                        "status": "shutting_down",
                        "message": "Service is shutting down gracefully"
                    })
                else:
                    self.json_response(200, {
                        "status": "healthy",
                        "active_requests": active_requests,
                        "timestamp": datetime.utcnow().isoformat()
                    })

            elif self.path == '/slow':
                # Simulate long-running request
                # Should complete even during shutdown
                time.sleep(3)
                self.json_response(200, {
                    "message": "Slow request completed",
                    "duration": "3 seconds"
                })

            else:
                self.json_response(200, {
                    "service": "graceful-shutdown-demo",
                    "active_requests": active_requests,
                    "shutting_down": shutdown_event.is_set()
                })
        finally:
            with requests_lock:
                active_requests -= 1

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


def handle_sigterm(signum, frame):
    """
    Handle SIGTERM signal gracefully
    This is called when docker stop is run
    """
    print(
        f"[{datetime.utcnow().isoformat()}] "
        f"SIGTERM received. Starting graceful shutdown...",
        flush=True
    )

    # Signal that we are shutting down
    # Health check will return 503
    # Load balancer stops routing here
    shutdown_event.set()

    # Wait for in-flight requests to complete
    max_wait = int(os.getenv('SHUTDOWN_TIMEOUT', '30'))
    print(
        f"Waiting up to {max_wait}s for "
        f"{active_requests} active requests...",
        flush=True
    )

    start = time.time()
    while active_requests > 0:
        if time.time() - start > max_wait:
            print(
                f"Timeout! Forcing shutdown with "
                f"{active_requests} requests pending",
                flush=True
            )
            break
        time.sleep(0.1)

    print("Graceful shutdown complete!", flush=True)
    # Exit cleanly
    import sys
    sys.exit(0)


# Register signal handlers
signal.signal(signal.SIGTERM, handle_sigterm)
signal.signal(signal.SIGINT, handle_sigterm)

if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))
    print(f"Starting graceful server on :{port}", flush=True)
    print(
        "Send SIGTERM (docker stop) to test graceful shutdown",
        flush=True
    )

    server = HTTPServer(('0.0.0.0', port), Handler)
    server.serve_forever()
