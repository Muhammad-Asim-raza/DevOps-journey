# Day 62 Exercises — AWS Lambda
**Date:** Aug 19 2026
**Status:** ✅ Completed

---

## Exercise 1: Lambda Anatomy ✅
- [x] Handler function signature (event, context)
- [x] Module-level initialization (warm start opt.)
- [x] Cold start vs warm start
- [x] JSON-structured logging
- [x] Error handling (400 vs 500)

### Proof: practices/day62-practice/exercise1-proof.txt

### Critical Pattern
```python
# Module level = runs ONCE on cold start
db_conn = psycopg2.connect(...)  # GOOD

def handler(event, context):
    # Runs every invocation
    result = db_conn.execute(...)  # Reuses connection!
```

---

## Exercise 2: Lambda Triggers ✅
- [x] S3 event notification setup
- [x] SQS event source mapping
- [x] EventBridge scheduled rules
- [x] Concurrency (reserved + provisioned)
- [x] DLQ and Destinations

### Proof: practices/day62-practice/exercise2-proof.txt

### SQS BatchItemFailure Pattern
Without: one message fails → entire batch retried
With ReportBatchItemFailures: only failed items retried
Always use for SQS triggers!

---

## Exercise 3: Lambda IAM ✅
- [x] Execution role trust policy
- [x] AWSLambdaBasicExecutionRole
- [x] Custom policies (S3, DynamoDB, SQS)
- [x] Secrets Manager for sensitive config
- [x] Least privilege per function

### Proof: practices/day62-practice/exercise3-proof.txt

---

## Exercise 4: CloudFormation Template ✅
- [x] Lambda function with all settings
- [x] IAM role with custom policies
- [x] SQS trigger + DLQ
- [x] EventBridge schedule
- [x] CloudWatch alarms
- [x] Lambda Layer

### Proof: practices/day62-practice/exercise4-proof.txt

---

## Functions Written

### hello-world/handler.py
Full anatomy with comments
Error handling pattern
Structured JSON logging

### s3-processor/handler.py
Process S3 ObjectCreated events
Write metadata to DynamoDB
URL-decode S3 object keys

### scheduled-task/handler.py
EventBridge cron trigger
Find old snapshots and stopped instances
Custom CloudWatch metrics
SES email reporting

### api-handler/handler.py
API Gateway routing pattern
Day 52 endpoints → Lambda version!
Response builder helper

---

## Summary
All 4 exercises completed Aug 19 2026

Files:
- lambda-functions/hello-world/handler.py
- lambda-functions/hello-world/test_handler.py
- lambda-functions/s3-processor/handler.py
- lambda-functions/scheduled-task/handler.py
- lambda-functions/api-handler/handler.py
- scripts/01-deploy-lambda.sh
- scripts/02-lambda-triggers.sh
- cfn-templates/lambda-stack.yaml
- lambda-reference.sh

Key concepts mastered:
- Serverless vs server (cost model)
- Cold start vs warm start optimization
- Handler anatomy (event, context)
- Module-level initialization pattern
- All trigger types (sync/async/polling)
- IAM execution role (least privilege)
- Reserved and provisioned concurrency
- DLQ and Destinations
- Lambda versions and aliases (canary)
- Lambda Layers (shared dependencies)
- CloudFormation for Lambda
- SQS BatchItemFailure pattern
- EventBridge cron schedule
- Custom CloudWatch metrics
- Lambda monitoring strategy
