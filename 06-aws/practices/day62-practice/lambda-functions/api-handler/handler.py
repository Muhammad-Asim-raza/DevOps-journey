"""
API Gateway Lambda Handler
Author: Asim Raza - Day 62
Trigger: API Gateway HTTP API
Pattern: REST API with routing
"""
import json
import os
import logging
import boto3
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Your Day 52 CI/CD Platform - now as Lambda!
BUILD_INFO = {
    "version": os.environ.get("APP_VERSION", "dev"),
    "commit": os.environ.get("GIT_COMMIT", "local")[:7],
    "environment": os.environ.get("ENVIRONMENT", "dev"),
}

START_TIME = datetime.utcnow()


def handler(event, context):
    """
    API Gateway event structure (HTTP API):
    {
      "routeKey": "GET /health",
      "rawPath": "/health",
      "rawQueryString": "param=value",
      "headers": {"content-type": "application/json"},
      "requestContext": {
        "http": {
          "method": "GET",
          "path": "/health"
        }
      },
      "body": "{...}" (string, must json.loads)
    }

    For REST API (different structure):
    {
      "httpMethod": "GET",
      "path": "/health",
      "queryStringParameters": {...},
      "body": "{...}"
    }
    """
    # Support both HTTP API and REST API
    method = (
        event.get("requestContext", {})
             .get("http", {})
             .get("method") or
        event.get("httpMethod", "GET")
    )
    path = (
        event.get("rawPath") or
        event.get("path", "/")
    )

    logger.info(json.dumps({
        "message": "API request",
        "method": method,
        "path": path,
        "requestId": context.aws_request_id,
    }))

    # Route the request
    routes = {
        ("GET", "/"): handle_home,
        ("GET", "/health"): handle_health,
        ("GET", "/build"): handle_build,
        ("GET", "/status"): handle_status,
    }

    handler_fn = routes.get((method, path))
    if handler_fn:
        return handler_fn(event, context)
    else:
        return response(404, {
            "error": "Not found",
            "path": path,
            "available": [
                f"{m} {p}"
                for m, p in routes.keys()
            ],
        })


def handle_home(event, context):
    return response(200, {
        "service": "devops-platform-lambda",
        "message": "Day 52 CI/CD project → Day 62 Lambda!",
        "author": "Asim Raza",
        "day": "62 of 120",
    })


def handle_health(event, context):
    uptime = (
        datetime.utcnow() - START_TIME
    ).total_seconds()
    return response(200, {
        "status": "healthy",
        "uptime_seconds": round(uptime, 1),
        "timestamp": datetime.utcnow().isoformat(),
    })


def handle_build(event, context):
    return response(200, BUILD_INFO)


def handle_status(event, context):
    return response(200, {
        "function": context.function_name,
        "version": context.function_version,
        "memory_mb": context.memory_limit_in_mb,
        "remaining_ms": context.get_remaining_time_in_millis(),
        "log_stream": context.log_stream_name,
    })


def response(status_code: int, body: dict,
             headers: dict = None) -> dict:
    """Build API Gateway response"""
    default_headers = {
        "Content-Type": "application/json",
        "X-Request-ID": "",
        "Access-Control-Allow-Origin": "*",
    }
    if headers:
        default_headers.update(headers)

    return {
        "statusCode": status_code,
        "body": json.dumps(body, default=str),
        "headers": default_headers,
    }
