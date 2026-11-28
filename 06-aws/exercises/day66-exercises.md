# Day 66 Exercises - AWS Load Balancers
**Date:** Aug 23 2026
**Status:** Completed

## Exercise 1: ELB Family
- [x] ALB vs NLB vs GWLB decision rules
- [x] LB > Listener > Rule > Target Group > Target
Proof: practices/day66-practice/exercise1-proof.txt

## Exercise 2: Build an ALB
- [x] SG-to-SG pattern (app accepts only the ALB SG)
- [x] Target group (type ip, /health, matcher 200)
- [x] Load balancer + listener, registered targets
- [x] HTTPS listener, 80->443 redirect, path/host rules
- [x] Weighted target groups for canary
Proof: practices/day66-practice/exercise2-proof.txt

## Exercise 3: Behavior
- [x] Cross-zone, stickiness, algorithms
- [x] Health check design (cheap /health)
- [x] Deregistration delay + graceful shutdown
- [x] X-Forwarded-For handling
Proof: practices/day66-practice/exercise3-proof.txt

## Exercise 4: Monitoring and Troubleshooting
- [x] Key metrics + alarm
- [x] 502/503/504 decoder
- [x] Unhealthy-target checklist
Proof: practices/day66-practice/exercise4-proof.txt

## Exercise 5: IaC
- [x] alb.yaml validated (SGs, ALB, TG, listeners, alarms)

## Connections
Day 55 SG-to-SG, Day 59/60 ECS+EKS targets, Day 64 alarms,
Day 65 Route 53 alias to the ALB, Day 52 /health and SIGTERM.
