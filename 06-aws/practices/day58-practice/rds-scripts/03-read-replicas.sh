#!/bin/bash
# ================================================
# 03-read-replicas.sh
# RDS Read Replicas - Scale Read Traffic
# Author: Asim Raza - Day 58
# ================================================

source ../rds-configs/rds-config.sh 2>/dev/null || {
    DB_IDENTIFIER="devops-journey-postgres"
    REGION="us-east-1"
}

echo "============================================"
echo "   RDS READ REPLICAS"
echo "   Scale reads. Don't overload primary."
echo "============================================"

echo ""
echo "[ READ REPLICA vs MULTI-AZ STANDBY ]"
echo ""
printf "%-30s %-25s %-25s\n" \
    "Feature" "Multi-AZ Standby" "Read Replica"
printf "%-30s %-25s %-25s\n" \
    "-------" "----------------" "------------"
printf "%-30s %-25s %-25s\n" \
    "Readable" "NO" "YES"
printf "%-30s %-25s %-25s\n" \
    "Purpose" "HA / Failover" "Scale reads"
printf "%-30s %-25s %-25s\n" \
    "Replication" "Synchronous" "Asynchronous"
printf "%-30s %-25s %-25s\n" \
    "Lag" "Zero (synchronous)" "Seconds to minutes"
printf "%-30s %-25s %-25s\n" \
    "Failover" "Automatic" "Manual promote"
printf "%-30s %-25s %-25s\n" \
    "Region" "Same region" "Same OR cross-region"
printf "%-30s %-25s %-25s\n" \
    "Count" "1 per instance" "Up to 5 (MySQL/PG)"
printf "%-30s %-25s %-25s\n" \
    "Cost" "2x primary" "1x primary + storage"

echo ""
echo "[ READ REPLICA ARCHITECTURE ]"
cat << 'DIAGRAM'

  Application
  ├── Writes → Primary (writer endpoint)
  └── Reads  → Read Replica(s) (reader endpoint)

  ┌─────────────────────────────────────────────┐
  │  us-east-1                                  │
  │  ┌─────────────────────────────────────┐    │
  │  │  PRIMARY (writer)                   │    │
  │  │  db.m5.large                        │    │
  │  │  Handles: writes + some reads       │    │
  │  └──────────────────┬──────────────────┘    │
  │                     │ async replication      │
  │                     ▼                       │
  │  ┌──────────────────────────────────────┐   │
  │  │  READ REPLICA 1  READ REPLICA 2     │   │
  │  │  db.r5.large     db.r5.large        │   │
  │  │  Reports/Dashboards                  │   │
  │  │  Analytics/Search                    │   │
  │  └──────────────────────────────────────┘   │
  │                                             │
  │  us-west-2 (cross-region replica)           │
  │  ┌────────────────────────────────────┐     │
  │  │  READ REPLICA 3                    │     │
  │  │  US West coast users               │     │
  │  │  DR: promote to primary if needed  │     │
  │  └────────────────────────────────────┘     │
  └─────────────────────────────────────────────┘

DIAGRAM

echo ""
echo "[ CREATE READ REPLICA ]"
echo ""

echo "  # Create replica in same region:"
echo "  aws rds create-db-instance-read-replica \\"
echo "    --db-instance-identifier ${DB_IDENTIFIER}-replica-1 \\"
echo "    --source-db-instance-identifier $DB_IDENTIFIER \\"
echo "    --db-instance-class db.t3.micro \\"
echo "    --availability-zone us-east-1b \\"
echo "    --port 5432 \\"
echo "    --no-publicly-accessible \\"
echo "    --tags Key=Name,Value=${DB_IDENTIFIER}-replica-1"
echo ""

aws rds create-db-instance-read-replica \
    --db-instance-identifier "${DB_IDENTIFIER}-replica-1" \
    --source-db-instance-identifier "$DB_IDENTIFIER" \
    --db-instance-class db.t3.micro \
    --no-publicly-accessible \
    --tags Key=Name,Value="${DB_IDENTIFIER}-replica-1" \
    --region "$REGION" 2>/dev/null && \
    echo "  ✅ Read replica creation started" || \
    echo "  (Configure credentials to create replica)"

echo ""
echo "  # Create cross-region replica (DR):"
echo "  aws rds create-db-instance-read-replica \\"
echo "    --db-instance-identifier ${DB_IDENTIFIER}-replica-dr \\"
echo "    --source-db-instance-identifier \\"
echo "      arn:aws:rds:us-east-1:ACCOUNT:db:${DB_IDENTIFIER} \\"
echo "    --db-instance-class db.t3.micro \\"
echo "    --region eu-west-1 \\"
echo "    --source-region us-east-1"

echo ""
echo "[ PROMOTE REPLICA TO STANDALONE DB ]"
echo ""
echo "  Use cases:"
echo "  - Cross-region DR: primary region fails → promote replica"
echo "  - Migration: create replica → catch up → promote → switch"
echo "  - Create dev/staging copy of production"
echo ""
echo "  aws rds promote-read-replica \\"
echo "    --db-instance-identifier ${DB_IDENTIFIER}-replica-1 \\"
echo "    --backup-retention-period 7 \\"
echo "    --preferred-backup-window '03:00-04:00'"
echo ""
echo "  After promote:"
echo "  - Replica becomes standalone database"
echo "  - Replication from primary STOPS"
echo "  - Update app to use new endpoint"

echo ""
echo "[ APPLICATION-LEVEL ROUTING ]"
echo ""
echo "  Option 1: Two connection strings in app"
cat << 'PYEOF'
import psycopg2

# Write operations → primary
write_conn = psycopg2.connect(
    host=PRIMARY_ENDPOINT,
    user=DB_USER, password=DB_PASS, database=DB_NAME
)

# Read operations → replica
read_conn = psycopg2.connect(
    host=REPLICA_ENDPOINT,
    user=DB_USER, password=DB_PASS, database=DB_NAME
)

# Usage:
# write_conn.cursor().execute("INSERT INTO ...")
# read_conn.cursor().execute("SELECT * FROM ...")
PYEOF

echo ""
echo "  Option 2: Aurora cluster endpoint (automatic)"
echo "  Cluster writer endpoint: always primary"
echo "  Cluster reader endpoint: load balances across replicas"
echo "  Application needs only TWO endpoints regardless of replicas"

echo ""
echo "[ SCALING STRATEGY ]"
echo ""
echo "  Read-heavy workload (80% reads, 20% writes):"
echo "  → Add read replicas to distribute reads"
echo "  → Route analytics/reports to replicas"
echo "  → Protect primary from heavy read load"
echo ""
echo "  Write-heavy workload:"
echo "  → Read replicas don't help writes"
echo "  → Consider: sharding, write-through cache"
echo "  → Or: scale up primary instance class"
echo "  → Application-level write optimization"
echo ""
echo "  Connection overload:"
echo "  → Use RDS Proxy (connection pooling)"
echo "  → Lambda functions often hit connection limits"
echo "  → See Lesson 5: RDS Proxy"

echo ""
echo "[ REPLICATION LAG MONITORING ]"
echo ""
echo "  Read replicas use ASYNC replication"
echo "  Primary write → confirmed to primary"
echo "  Replica update → happens shortly after"
echo "  Gap = replication lag"
echo ""
echo "  Monitor: CloudWatch > ReplicaLag (seconds)"
echo "  Alert if: lag > 60 seconds"
echo "  Cause: heavy write load on primary"
echo ""
echo "  # Check replica lag:"
echo "  aws cloudwatch get-metric-statistics \\"
echo "    --namespace AWS/RDS \\"
echo "    --metric-name ReplicaLag \\"
echo "    --dimensions Name=DBInstanceIdentifier,Value=${DB_IDENTIFIER}-replica-1 \\"
echo "    --start-time \$(date -u -d '5 minutes ago' +%Y-%m-%dT%H:%M:%SZ) \\"
echo "    --end-time \$(date -u +%Y-%m-%dT%H:%M:%SZ) \\"
echo "    --period 60 \\"
echo "    --statistics Average"

echo ""
echo "============================================"
echo "   READ REPLICAS COMPLETE"
echo "============================================"
