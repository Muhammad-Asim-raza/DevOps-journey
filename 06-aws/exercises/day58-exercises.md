# Day 58 Exercises — AWS RDS
**Date:** Aug 15 2026
**Status:** ✅ Completed

---

## Exercise 1: RDS Creation ✅
- [x] DB subnet group (private subnets, 2+ AZs)
- [x] DB security group (port 5432 from App-SG)
- [x] Password in Secrets Manager
- [x] Full create-db-instance command with all flags
- [x] Connection string formats

### Proof: practices/day58-practice/exercise1-proof.txt

### Critical Flags
--storage-encrypted        (always)
--no-publicly-accessible   (always)
--deletion-protection      (production)
--multi-az                 (production)
Password: Secrets Manager (not CLI arg!)

---

## Exercise 2: Multi-AZ vs Read Replicas ✅
- [x] Multi-AZ standby explained
- [x] Read replicas created
- [x] Cross-region replica for DR
- [x] Promote replica walkthrough
- [x] Replication lag monitoring

### Proof: practices/day58-practice/exercise2-proof.txt

### Key Distinction
Multi-AZ: HA/failover (NOT readable)
Read Replica: scale reads (IS readable)
Both can coexist: Multi-AZ primary + replicas

---

## Exercise 3: Backups and Point-in-Time Restore ✅
- [x] Automated backup configuration
- [x] Manual snapshot creation
- [x] Cross-region snapshot copy
- [x] Point-in-time restore command
- [x] Best practices documented

### Proof: practices/day58-practice/exercise3-proof.txt

### Point-in-Time Restore
restores to NEW instance (not overwrite!)
aws rds restore-db-instance-to-point-in-time \
  --source-db-instance-identifier SOURCE \
  --target-db-instance-identifier TARGET \
  --restore-time 2024-08-14T08:59:59Z

---

## Exercise 4: Aurora and RDS Proxy ✅
- [x] Aurora vs RDS differences
- [x] Aurora cluster endpoints
- [x] Aurora Serverless v2
- [x] RDS Proxy connection pooling
- [x] Lambda + RDS Proxy pattern

### Proof: practices/day58-practice/exercise4-proof.txt

### Aurora Cluster Create
Create cluster → add writer instance → add reader instances
Writer endpoint: always current primary
Reader endpoint: load-balances all readers

---

## Summary
All 4 exercises completed Aug 15 2026

Scripts created:
- rds-scripts/01-create-rds.sh
- rds-scripts/02-backups-restore.sh
- rds-scripts/03-read-replicas.sh
- rds-scripts/04-aurora-proxy.sh
- rds-scripts/05-rds-management.sh
- rds-configs/lifecycle-policy.json
- rds-configs/parameter-settings.sh
- rds-reference.sh

Key concepts mastered:
- RDS vs self-managed databases
- Supported engines (MySQL PG Aurora Oracle MSSQL)
- Multi-AZ (HA, standby NOT readable)
- Read replicas (scale reads, async)
- Automated backups + point-in-time restore
- Manual snapshots (before every major change)
- Aurora distributed storage architecture
- Aurora vs RDS key differences
- Aurora Serverless v2
- RDS Proxy connection pooling
- Parameter groups (database configuration)
- CloudWatch metrics for RDS
- Security (private subnet, SG, encryption, Secrets Manager)
- CLI commands for all operations
