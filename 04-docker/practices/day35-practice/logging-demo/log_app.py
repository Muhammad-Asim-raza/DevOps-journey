#!/usr/bin/env python3
"""
Production Logging Demo
Author: Asim Raza - Day 35
Demonstrates: structured logging, log levels, JSON logs
"""
import json
import logging
import os
import sys
import time
import random
from datetime import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler


# Structured JSON logger
class JSONFormatter(logging.Formatter):
    """Format logs as JSON for easy parsing"""

    def format(self, record):
        log_obj = {
            "timestamp": datetime.utcnow().isoformat(),
            "level":     record.levelname,
            "logger":    record.name,
            "message":   record.getMessage(),
            "service":   "logging-demo",
            "version":   os.getenv("APP_VERSION", "1.0.0"),
        }
        if record.exc_info:
            log_obj["exception"] = \
                self.formatException(record.exc_info)
        return json.dumps(log_obj)


# Configure logging
log_level = os.getenv("LOG_LEVEL", "INFO").upper()
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(JSONFormatter())

logger = logging.getLogger("app")
logger.setLevel(getattr(logging, log_level, logging.INFO))
logger.addHandler(handler)
logger.propagate = False


class LoggingHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        start = time.time()

        logger.info(
            "Request received",
            extra={"path": self.path}
        )

        if self.path == '/health':
            self.respond(200, {"status": "healthy"})
            logger.debug("Health check passed")

        elif self.path == '/generate-logs':
            # Generate various log levels
            logger.debug("Debug: detailed trace info")
            logger.info("Info: normal operation")
            logger.warning("Warning: something unusual")

            # Occasionally generate errors
            if random.random() < 0.3:
                logger.error(
                    "Error: simulated failure",
                    extra={"error_code": "SIM_001"}
                )

            self.respond(200, {"message": "Logs generated"})

        elif self.path == '/error':
            try:
                raise ValueError(
                    "Simulated application error"
                )
            except ValueError as e:
                logger.exception(
                    f"Application error: {e}"
                )
                self.respond(500, {"error": str(e)})
        else:
            self.respond(200, {
                "service": "logging-demo",
                "log_level": log_level,
                "endpoints": [
                    "/health",
                    "/generate-logs",
                    "/error"
                ]
            })

        duration = time.time() - start
        logger.info(
            "Request completed",
            extra={
                "path": self.path,
                "duration_ms": round(duration * 1000, 2),
                "status": "200"
            }
        )

    def respond(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Content-Length', len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass  # Suppress default logging (we use our own)


if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))
    logger.info(f"Application starting on port {port}")
    HTTPServer(('0.0.0.0', port), LoggingHandler).serve_forever()
