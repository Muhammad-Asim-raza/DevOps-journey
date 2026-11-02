"""
Lambda Handler Anatomy
Author: Asim Raza - Day 62
Every field and pattern explained
"""
import json
import os
import logging
import boto3
from datetime import datetime

# ── MODULE-LEVEL CODE (runs once on cold start) ─────
# Initialize logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)
# logging.INFO = balance (not too verbose)
# In production: use LOG_LEVEL env var

# Initialize AWS clients ONCE (warm start reuse)
s3_client = boto3.client('s3')
# Creating boto3 client here = fast warm starts
# Creating inside handler = slow every invocation

# Load config ONCE
BUCKET_NAME = os.environ.get('BUCKET_NAME', '')
ENVIRONMENT = os.environ.get('ENVIRONMENT', 'development')
# os.environ: Lambda environment variables
# Set in: console, CLI, CloudFormation, Terraform

# ── HANDLER FUNCTION ────────────────────────────────
def handler(event, context):
    """
    Lambda handler function.

    Parameters
    ----------
    event : dict
        The triggering event payload.
        Shape depends on trigger source:
        - API Gateway: {httpMethod, path, body, headers, ...}
        - S3: {Records: [{s3: {bucket, object}}]}
        - SQS: {Records: [{body, messageId, ...}]}
        - EventBridge: {source, detail-type, detail, ...}
        - Direct invoke: whatever YOU send

    context : LambdaContext
        Runtime information:
        context.function_name     → 'my-function'
        context.function_version  → '$LATEST' or '1'
        context.invoked_function_arn
        context.memory_limit_in_mb → '512'
        context.aws_request_id    → unique per invocation
        context.get_remaining_time_in_millis() → ms left
        context.log_stream_name   → CloudWatch stream

    Returns
    -------
    dict or any JSON-serializable value
        For API Gateway: must return
        {statusCode, body, headers}
        For async triggers (S3, SQS): return value ignored
        On error: raise exception (Lambda retries if async)
    """

    # ── Log invocation ───────────────────────────────
    logger.info(json.dumps({
        "message": "Lambda invoked",
        "function": context.function_name,
        "request_id": context.aws_request_id,
        "remaining_ms": context.get_remaining_time_in_millis(),
        "environment": ENVIRONMENT,
        "event_keys": list(event.keys()) if event else [],
    }))
    # JSON-structured logging = easy CloudWatch Insights queries

    # ── Process the event ────────────────────────────
    try:
        result = process_event(event, context)
        logger.info(json.dumps({
            "message": "Processing complete",
            "result": str(result)[:200],
        }))
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Success",
                "result": result,
                "requestId": context.aws_request_id,
                "timestamp": datetime.utcnow().isoformat(),
            }),
            "headers": {
                "Content-Type": "application/json",
                "X-Request-ID": context.aws_request_id,
            }
        }

    except ValueError as e:
        # Client error: 400
        logger.warning(json.dumps({
            "message": "Client error",
            "error": str(e),
        }))
        return {
            "statusCode": 400,
            "body": json.dumps({"error": str(e)}),
        }

    except Exception as e:
        # Server error: 500
        logger.error(json.dumps({
            "message": "Unhandled error",
            "error": str(e),
            "type": type(e).__name__,
        }))
        # For async invocations: raise to trigger retry
        # For sync (API GW): return 500 response
        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": "Internal server error",
                "requestId": context.aws_request_id,
            }),
        }


def process_event(event: dict, context) -> dict:
    """Actual business logic"""
    name = event.get("name", "World")

    # Validate input
    if not isinstance(name, str):
        raise ValueError("'name' must be a string")
    if len(name) > 100:
        raise ValueError("'name' must be <= 100 chars")

    return {
        "greeting": f"Hello, {name}!",
        "function": context.function_name,
        "environment": ENVIRONMENT,
    }
