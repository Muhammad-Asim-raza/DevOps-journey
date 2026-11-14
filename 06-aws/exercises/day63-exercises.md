# Day 63 Exercises - AWS API Gateway
**Date:** Aug 20 2026
**Status:** Completed

## Exercise 1: HTTP API to Lambda
- [x] create-api, create-integration (AWS_PROXY, payload 2.0)
- [x] Routes: GET /, /health, /build, /status
- [x] lambda add-permission scoped to this API's ARN
- [x] Stage with auto-deploy and throttling
Proof: practices/day63-practice/exercise1-proof.txt

## Exercise 2: Authorization
- [x] Lambda authorizer written (constant-time compare)
- [x] JWT authorizer command documented
- [x] IAM auth with SigV4 documented
- [x] Decision table: which to use when
Proof: practices/day63-practice/exercise2-proof.txt

## Exercise 3: Throttling and Usage Plans
- [x] Rate vs burst explained
- [x] Per-route throttling
- [x] REST usage plan + API key flow
- [x] API keys are metering, not security
Proof: practices/day63-practice/exercise3-proof.txt

## Exercise 4: CORS and Troubleshooting
- [x] Preflight flow explained
- [x] HTTP API CORS configuration
- [x] Error decoder (401/403/404/429/500/502/504)
- [x] Debug workflow
Proof: practices/day63-practice/exercise4-proof.txt

## Exercise 5: Infrastructure as Code
- [x] http-api.yaml with access logs, stage, throttling
- [x] Conditions for prod vs non-prod limits
- [x] validate-template + deploy

## Connections
Day 52 API -> Day 62 Lambda -> Day 63 public HTTPS endpoint
Day 61 CloudFormation used to define it

## Summary
Files: 5 scripts, authorizer code, CloudFormation template,
reference script, 4 proof files.
