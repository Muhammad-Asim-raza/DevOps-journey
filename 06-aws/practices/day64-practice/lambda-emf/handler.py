"""
Lambda that emits custom metrics via Embedded Metric Format (EMF).
Author: Asim Raza - Day 64

Printing this JSON to stdout is enough. No put_metric_data call,
no extra API latency. CloudWatch parses the "_aws" block and
creates the metrics; the remaining fields stay searchable in Logs.
"""
import json
import time

NAMESPACE = "DevOpsJourney/App"


def emit_metric(name, value, unit="Count", **dimensions):
    """Print one EMF log line."""
    record = {
        "_aws": {
            "Timestamp": int(time.time() * 1000),
            "CloudWatchMetrics": [{
                "Namespace": NAMESPACE,
                "Dimensions": [list(dimensions.keys())],
                "Metrics": [{"Name": name, "Unit": unit}],
            }],
        },
        name: value,
        **dimensions,
    }
    print(json.dumps(record))


def handler(event, context):
    start = time.time()
    emit_metric("OrdersProcessed", 1, service="checkout",
                environment="staging")
    # ... real work here ...
    elapsed_ms = (time.time() - start) * 1000
    emit_metric("ProcessingTime", elapsed_ms, unit="Milliseconds",
                service="checkout", environment="staging")
    return {"statusCode": 200, "body": json.dumps({"ok": True})}
