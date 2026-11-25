# Day 65 Exercises - AWS Route 53
**Date:** Aug 22 2026
**Status:** Completed

## Exercise 1: Zones and Records
- [x] Public hosted zone + delegation understood
- [x] UPSERT change batch (A, TXT)
- [x] Alias vs CNAME explained
- [x] TTL strategy for migrations
Proof: practices/day65-practice/exercise1-proof.txt

## Exercise 2: Routing Policies
- [x] Weighted 90/10 canary JSON
- [x] Failover primary/secondary JSON
- [x] SetIdentifier mechanics
Proof: practices/day65-practice/exercise2-proof.txt

## Exercise 3: Health Checks
- [x] Endpoint health check config
- [x] CloudWatch alarm (us-east-1 metric)
- [x] Checker IP ranges / SG gotcha
Proof: practices/day65-practice/exercise3-proof.txt

## Exercise 4: Custom Domain + Private Zone
- [x] ACM + API GW custom domain + ALIAS steps
- [x] Private hosted zone with VPC association
Proof: practices/day65-practice/exercise4-proof.txt

## Exercise 5: DNS as Code + Troubleshooting
- [x] dns.yaml (health check + failover) validated
- [x] dig workflow and symptom table

## Connections
Days 11-18 DNS theory -> Route 53
Day 55 VPC DNS settings -> private zones
Day 63 API -> custom domain
Day 64 CloudWatch -> health check alarms
Day 61 CloudFormation -> DNS as code
