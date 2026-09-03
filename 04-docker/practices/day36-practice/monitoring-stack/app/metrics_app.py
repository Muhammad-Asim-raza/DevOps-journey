#!/usr/bin/env python3
"""
Application with Prometheus Metrics
Author: Asim Raza - Day 36
Exposes: request counter, latency histogram, custom gauges
"""
import time
import random
import json
import os
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime

# ── Prometheus Metrics Implementation ──
# In production: use prometheus_client library
# Here: manual implementation to understand internals

class MetricsRegistry:
    """Simple metrics registry"""

    def __init__(self):
        self._counters = {}
        self._gauges = {}
        self._histograms = {}
        self._lock = threading.Lock()

    def counter(self, name, labels=None):
        key = (name, frozenset((labels or {}).items()))
        with self._lock:
            if key not in self._counters:
                self._counters[key] = 0
        return key

    def inc(self, key, value=1):
        with self._lock:
            self._counters[key] = \
                self._counters.get(key, 0) + value

    def gauge_set(self, name, value, labels=None):
        key = (name, frozenset((labels or {}).items()))
        with self._lock:
            self._gauges[key] = value

    def observe(self, name, value, labels=None):
        key = (name, frozenset((labels or {}).items()))
        with self._lock:
            if key not in self._histograms:
                self._histograms[key] = []
            self._histograms[key].append(value)

    def generate_text(self):
        """Generate Prometheus text format"""
        lines = []

        # Counters
        for (name, labels), value in self._counters.items():
            label_str = self._labels_str(dict(labels))
            lines.append(f"# TYPE {name} counter")
            lines.append(f"{name}{label_str} {value}")

        # Gauges
        for (name, labels), value in self._gauges.items():
            label_str = self._labels_str(dict(labels))
            lines.append(f"# TYPE {name} gauge")
            lines.append(f"{name}{label_str} {value:.4f}")

        # Histograms (simplified)
        for (name, labels), values in \
                self._histograms.items():
            if not values:
                continue
            label_str = self._labels_str(dict(labels))
            sorted_v = sorted(values)
            n = len(sorted_v)
            lines.append(f"# TYPE {name} histogram")
            lines.append(
                f"{name}_count{label_str} {n}"
            )
            lines.append(
                f"{name}_sum{label_str} {sum(sorted_v):.4f}"
            )
            for p, q in [(0.5, 'p50'), (0.9, 'p90'),
                         (0.99, 'p99')]:
                idx = max(0, int(p * n) - 1)
                lines.append(
                    f"{name}_{q}{label_str} "
                    f"{sorted_v[idx]:.4f}"
                )

        return "\n".join(lines) + "\n"

    def _labels_str(self, labels):
        if not labels:
            return ""
        parts = [f'{k}="{v}"' for k, v in labels.items()]
        return "{" + ",".join(parts) + "}"


registry = MetricsRegistry()

# Define metrics
http_requests_total = "http_requests_total"
http_request_duration = "http_request_duration_seconds"
active_connections = "app_active_connections"
error_total = "http_errors_total"

# Initialize
registry.counter(http_requests_total)
registry.gauge_set(active_connections, 0)
active_count = 0
active_lock = threading.Lock()


class MetricsHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        global active_count
        start = time.time()

        with active_lock:
            active_count += 1
            registry.gauge_set(
                active_connections, active_count
            )

        try:
            self._handle()
        finally:
            duration = time.time() - start
            with active_lock:
                active_count -= 1
                registry.gauge_set(
                    active_connections, active_count
                )

            # Record metrics
            labels = {"path": self.path,
                      "method": "GET"}
            registry.inc(
                registry.counter(
                    http_requests_total, labels
                )
            )
            registry.observe(
                http_request_duration, duration, labels
            )

    def _handle(self):
        if self.path == '/metrics':
            self._metrics()
        elif self.path == '/health':
            self._json(200, {
                "status": "healthy",
                "timestamp": datetime.utcnow().isoformat()
            })
        elif self.path == '/load':
            # Simulate variable load
            time.sleep(random.uniform(0.01, 0.5))
            self._json(200, {"simulated": "load"})
        elif self.path == '/error':
            # Simulate errors
            registry.inc(
                registry.counter(
                    error_total,
                    {"type": "simulated"}
                )
            )
            self._json(500, {"error": "simulated"})
        else:
            self._json(200, {
                "service": "metrics-demo",
                "endpoints": [
                    "/metrics",
                    "/health",
                    "/load",
                    "/error"
                ]
            })

    def _metrics(self):
        body = registry.generate_text().encode()
        self.send_response(200)
        self.send_header(
            'Content-Type',
            'text/plain; version=0.0.4'
        )
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)

    def _json(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header(
            'Content-Type', 'application/json'
        )
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        print(
            json.dumps({
                "timestamp": datetime.utcnow().isoformat(),
                "level": "INFO",
                "message": fmt % args,
                "service": "metrics-demo"
            }),
            flush=True
        )


# Background load simulator
def generate_load():
    """Simulate background traffic for metrics demo"""
    import urllib.request
    port = int(os.getenv('PORT', 8000))
    while True:
        try:
            # Simulate various endpoints
            path = random.choice(
                ['/', '/health', '/load', '/error',
                 '/load', '/load', '/load']
            )
            url = f'http://localhost:{port}{path}'
            urllib.request.urlopen(url, timeout=1)
        except Exception:
            pass
        time.sleep(random.uniform(0.1, 1.0))


if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))

    # Start background load
    threading.Thread(
        target=generate_load, daemon=True
    ).start()

    print(
        json.dumps({
            "timestamp": datetime.utcnow().isoformat(),
            "level": "INFO",
            "message": f"Metrics app starting on :{port}",
            "service": "metrics-demo"
        }),
        flush=True
    )

    HTTPServer(('0.0.0.0', port), MetricsHandler).serve_forever()
