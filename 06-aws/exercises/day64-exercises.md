# Day 64 Exercises - AWS CloudWatch
**Date:** Aug 21 2026
**Status:** Completed

## Exercise 1: Metrics
- [x] list-metrics, get-metric-statistics, get-metric-data
- [x] Metric math for error rate %
- [x] Custom metric via put-metric-data
- [x] EMF Lambda handler (lambda-emf/handler.py)
Proof: practices/day64-practice/exercise1-proof.txt

## Exercise 2: Logs
- [x] Retention policy on every log group
- [x] Logs Insights queries (errors, p95, cold starts, slow routes)
- [x] Metric filter turning ERROR lines into a metric
Proof: practices/day64-practice/exercise2-proof.txt

## Exercise 3: Alarms
- [x] SNS topic + confirmed email subscription
- [x] Lambda errors, p99 duration (M of N), RDS low storage
- [x] Billing alarm in us-east-1
- [x] Tested with set-alarm-state
Proof: practices/day64-practice/exercise3-proof.txt

## Exercise 4: Dashboards, Agent, IaC
- [x] Dashboard JSON (golden signals)
- [x] CloudWatch Agent config (mem, disk, logs)
- [x] monitoring.yaml (SNS, alarms, dashboard) validated
Proof: practices/day64-practice/exercise4-proof.txt

## Connections
Day 53 billing alert promise -> real billing alarm
Day 56 EC2 -> agent for memory/disk
Day 58 RDS metrics, Day 62 Lambda metrics, Day 63 API access logs
Day 61 CloudFormation defines the monitoring

## Summary
4 scripts, EMF handler, dashboard JSON, agent config,
CloudFormation template, reference script, 4 proof files.
