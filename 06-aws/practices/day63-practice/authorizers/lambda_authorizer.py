"""
Lambda Authorizer (HTTP API, payload format 2.0, simple response)
Author: Asim Raza - Day 63

Flow:
  Client -> API Gateway -> THIS Lambda -> {"isAuthorized": bool}
  If true, API Gateway forwards to the backend Lambda.
  If false, the client gets 403.

DEMO ONLY: a real authorizer validates a signed JWT or looks the key
up in Secrets Manager / DynamoDB. Never hardcode secrets in code.
"""
import hmac
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Loaded once per cold start. In production read this from
# Secrets Manager (cache it), not a plain environment variable.
EXPECTED_TOKEN = os.environ.get("EXPECTED_TOKEN", "")


def handler(event, context):
    """
    event (simple-response, v2.0) looks like:
    {
      "version": "2.0",
      "type": "REQUEST",
      "routeKey": "GET /status",
      "headers": {"authorization": "Bearer abc"},
      "requestContext": {"http": {"method": "GET", "path": "/status"}}
    }
    HTTP API lower-cases header names.
    """
    headers = event.get("headers") or {}
    auth = headers.get("authorization", "")

    token = auth[7:] if auth.startswith("Bearer ") else ""

    # constant-time comparison prevents timing attacks
    allowed = bool(EXPECTED_TOKEN) and hmac.compare_digest(
        token.encode(), EXPECTED_TOKEN.encode()
    )

    logger.info("auth decision route=%s allowed=%s",
                event.get("routeKey"), allowed)

    return {
        "isAuthorized": allowed,
        # context is passed to the backend Lambda as
        # event["requestContext"]["authorizer"]["lambda"]
        "context": {"principalId": "demo-user" if allowed else "anonymous"},
    }
