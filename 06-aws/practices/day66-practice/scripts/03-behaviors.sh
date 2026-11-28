#!/bin/bash
echo "============================================"
echo "   LOAD BALANCER BEHAVIOR"
echo "============================================"
cat << 'EOF'
[ ALGORITHMS ]
  ALB default: round robin.
  Optional: least outstanding requests (good when request cost varies).
  NLB: flow-hash (same connection to the same target).

[ CROSS-ZONE LOAD BALANCING ]
  ALB: always on, no charge for inter-AZ data.
  NLB: OFF by default; when enabled you pay inter-AZ transfer.
  Without it, uneven target counts per AZ get uneven load
  (2 targets in AZ-a, 8 in AZ-b: each AZ node gets 50% of traffic
  so each AZ-a target takes 25% and each AZ-b target 6%).

[ STICKY SESSIONS ]
  ALB duration-based cookie (AWSALB) or application cookie.
  aws elbv2 modify-target-group-attributes --target-group-arn $TG \
    --attributes Key=stickiness.enabled,Value=true \
                 Key=stickiness.type,Value=lb_cookie \
                 Key=stickiness.lb_cookie.duration_seconds,Value=3600
  Prefer stateless apps (sessions in Redis/DynamoDB). Stickiness
  causes uneven load and loses sessions when a target dies.

[ HEALTH CHECKS ]
  A target needs N consecutive successes to become healthy, M
  consecutive failures to become unhealthy.
  If ALL targets are unhealthy, ALB "fails open" and routes to all
  of them rather than serving nothing.
  Make /health cheap. A /health that queries the database makes a
  DB blip mark EVERY target unhealthy at once = total outage.
  (Day 52: /health = liveness, /ready = dependencies.)

[ DEREGISTRATION DELAY (connection draining) ]
  Target being removed stops receiving NEW requests, existing ones
  get up to this long to finish. Default 300 s; 30-60 s is typical
  for short HTTP requests. Pair with your app's SIGTERM handling
  (Day 52 graceful shutdown) and ECS stopTimeout.

[ SLOW START ]
  Ramp traffic to a newly healthy target over N seconds so cold
  caches/JIT aren't hammered.

[ WEBSOCKETS / LONG REQUESTS ]
  ALB supports WebSockets. Idle timeout (60 s) closes quiet
  connections; send keepalives or raise the timeout.

[ NLB SPECIFICS ]
  Static IP/Elastic IP per AZ. TLS listeners supported.
  Preserves client source IP (instance targets).
  No security group on NLB historically; newer NLBs can have one.
  Target health still matters; use TCP or HTTP health checks.

[ LIMITS TO KNOW ]
  ALB scales automatically but not instantly: for a massive,
  sudden spike (launch day) ask AWS to pre-warm.
  Request header and URL size limits exist; large payloads go
  direct to S3 via presigned URL (Day 57).
EOF
echo "============================================"
