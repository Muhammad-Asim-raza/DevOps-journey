"""
S3 Event Processor Lambda
Author: Asim Raza - Day 62
Trigger: S3 ObjectCreated events
Use case: Process uploaded files
"""
import json
import os
import logging
import urllib.parse
import boto3
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize clients at module level
s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

# Environment variables
METADATA_TABLE = os.environ.get('METADATA_TABLE', '')
PROCESSED_BUCKET = os.environ.get('PROCESSED_BUCKET', '')


def handler(event, context):
    """
    Process S3 upload events.

    S3 event structure:
    {
      "Records": [
        {
          "eventName": "ObjectCreated:Put",
          "s3": {
            "bucket": {"name": "my-bucket"},
            "object": {
              "key": "uploads/photo.jpg",
              "size": 1024,
              "eTag": "abc123"
            }
          }
        }
      ]
    }
    """
    logger.info(f"Processing {len(event['Records'])} S3 records")

    results = []
    for record in event['Records']:
        try:
            result = process_s3_record(record)
            results.append({"status": "success", "key": result})
        except Exception as e:
            logger.error(json.dumps({
                "message": "Failed to process record",
                "error": str(e),
                "record": json.dumps(record)[:500],
            }))
            # For S3 triggers: raise to trigger retry
            raise

    return {"processed": len(results), "results": results}


def process_s3_record(record: dict) -> str:
    """Process a single S3 record"""
    event_name = record['eventName']
    bucket = record['s3']['bucket']['name']
    # URL-decode the key (S3 encodes special chars)
    key = urllib.parse.unquote_plus(
        record['s3']['object']['key']
    )
    size = record['s3']['object']['size']

    logger.info(json.dumps({
        "message": "Processing S3 object",
        "event": event_name,
        "bucket": bucket,
        "key": key,
        "size": size,
    }))

    # Get object metadata
    response = s3.head_object(Bucket=bucket, Key=key)
    content_type = response.get('ContentType', 'unknown')

    # Store metadata in DynamoDB
    if METADATA_TABLE:
        table = dynamodb.Table(METADATA_TABLE)
        table.put_item(Item={
            'objectKey': key,
            'bucket': bucket,
            'size': size,
            'contentType': content_type,
            'processedAt': datetime.utcnow().isoformat(),
            'eventName': event_name,
        })

    logger.info(f"Processed: s3://{bucket}/{key}")
    return key
