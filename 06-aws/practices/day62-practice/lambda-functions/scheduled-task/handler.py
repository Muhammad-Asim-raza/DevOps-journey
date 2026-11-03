"""
Scheduled Task Lambda
Author: Asim Raza - Day 62
Trigger: EventBridge (CloudWatch Events) cron schedule
Use case: Periodic cleanup, reporting, health checks
"""
import json
import os
import logging
import boto3
from datetime import datetime, timedelta

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2 = boto3.client('ec2')
cloudwatch = boto3.client('cloudwatch')
ses = boto3.client('ses')

MAX_SNAPSHOT_AGE_DAYS = int(
    os.environ.get('MAX_SNAPSHOT_AGE_DAYS', '30')
)
REPORT_EMAIL = os.environ.get('REPORT_EMAIL', '')


def handler(event, context):
    """
    EventBridge scheduled event.

    EventBridge event structure:
    {
      "version": "0",
      "source": "aws.events",
      "detail-type": "Scheduled Event",
      "time": "2024-08-19T02:00:00Z",
      "resources": ["arn:aws:events:us-east-1:...rule/daily-cleanup"]
    }
    """
    logger.info(json.dumps({
        "message": "Scheduled task starting",
        "source": event.get("source"),
        "time": event.get("time"),
    }))

    results = {}

    # Task 1: Find and report old snapshots
    results['old_snapshots'] = find_old_snapshots()

    # Task 2: Check for stopped instances
    results['stopped_instances'] = find_stopped_instances()

    # Task 3: Publish custom metric
    publish_health_metric(len(results['old_snapshots']))

    # Task 4: Send daily report
    if REPORT_EMAIL:
        send_report(results)

    logger.info(json.dumps({
        "message": "Scheduled task complete",
        "results_summary": {
            k: len(v) for k, v in results.items()
        }
    }))
    return results


def find_old_snapshots() -> list:
    """Find EBS snapshots older than threshold"""
    cutoff = datetime.utcnow() - timedelta(
        days=MAX_SNAPSHOT_AGE_DAYS
    )

    try:
        response = ec2.describe_snapshots(
            OwnerIds=['self']
        )
        old_snaps = [
            {
                "SnapshotId": s['SnapshotId'],
                "StartTime": s['StartTime'].isoformat(),
                "VolumeSize": s['VolumeSize'],
                "Description": s.get('Description', ''),
            }
            for s in response.get('Snapshots', [])
            if s['StartTime'].replace(tzinfo=None) < cutoff
        ]
        logger.info(
            f"Found {len(old_snaps)} old snapshots"
        )
        return old_snaps
    except Exception as e:
        logger.error(f"Snapshot query failed: {e}")
        return []


def find_stopped_instances() -> list:
    """Find EC2 instances stopped for > 7 days"""
    try:
        response = ec2.describe_instances(
            Filters=[
                {'Name': 'instance-state-name',
                 'Values': ['stopped']}
            ]
        )
        stopped = []
        for reservation in response.get('Reservations', []):
            for inst in reservation.get('Instances', []):
                stopped.append({
                    "InstanceId": inst['InstanceId'],
                    "InstanceType": inst['InstanceType'],
                    "Name": next(
                        (t['Value'] for t in
                         inst.get('Tags', [])
                         if t['Key'] == 'Name'),
                        'unnamed'
                    ),
                })
        return stopped
    except Exception as e:
        logger.error(f"Instance query failed: {e}")
        return []


def publish_health_metric(old_snapshot_count: int):
    """Send custom CloudWatch metric"""
    try:
        cloudwatch.put_metric_data(
            Namespace='DevOpsJourney/Cleanup',
            MetricData=[{
                'MetricName': 'OldSnapshotCount',
                'Value': old_snapshot_count,
                'Unit': 'Count',
                'Dimensions': [{
                    'Name': 'Environment',
                    'Value': os.environ.get(
                        'ENVIRONMENT', 'unknown'
                    ),
                }]
            }]
        )
    except Exception as e:
        logger.error(f"CloudWatch metric failed: {e}")


def send_report(results: dict):
    """Send summary email via SES"""
    try:
        body = f"""
Daily AWS Cleanup Report
Generated: {datetime.utcnow().isoformat()}

Old Snapshots (>{MAX_SNAPSHOT_AGE_DAYS} days): {len(results.get('old_snapshots', []))}
Stopped Instances: {len(results.get('stopped_instances', []))}
        """.strip()

        ses.send_email(
            Source=REPORT_EMAIL,
            Destination={'ToAddresses': [REPORT_EMAIL]},
            Message={
                'Subject': {'Data': 'Daily AWS Report'},
                'Body': {'Text': {'Data': body}}
            }
        )
    except Exception as e:
        logger.error(f"Email send failed: {e}")
