#!/bin/bash
# ================================================
# 01-create-rds.sh
# Create RDS PostgreSQL Instance - Full Walkthrough
# Author: Asim Raza - Day 58
# ================================================
set -euo pipefail

REGION="${AWS_DEFAULT_REGION:-us-east-1}"
APP_NAME="devops-journey"
DB_IDENTIFIER="${APP_NAME}-postgres"
DB_ENGINE="postgres"
DB_ENGINE_VERSION="16.3"
DB_INSTANCE_CLASS="db.t3.micro"
DB_NAME="devopsdb"
DB_USER="dbadmin"
DB_PORT="5432"

echo "============================================"
echo "   CREATE RDS POSTGRESQL INSTANCE"
echo "   Author: Asim Raza - Day 58"
echo "============================================"
echo ""
echo "  DB Identifier: $DB_IDENTIFIER"
echo "  Engine:        $DB_ENGINE $DB_ENGINE_VERSION"
echo "  Instance:      $DB_INSTANCE_CLASS"
echo "  Region:        $REGION"

# ── STEP 1: Create DB Subnet Group ──────────────
echo ""
echo "[ STEP 1: Create DB Subnet Group ]"
echo ""
echo "  DB Subnet Group = which subnets RDS can use"
echo "  Must span at least 2 AZs (for Multi-AZ)"
echo "  Use PRIVATE subnets (database layer)"
echo "  NEVER put RDS in public subnets!"
echo ""

# Get private subnets from default VPC for demo
# In production: use your custom VPC's DB subnets
VPC_ID="vpc-demo"
echo "aws ec2 describe-vpcs \
    --filters 'Name=isDefault,Values=true' \
    --query 'Vpcs[0].VpcId' \
    --output text \
    --region \"$REGION\""

SUBNET_IDS="subnet-demo1 subnet-demo2"
echo "aws ec2 describe-subnets \
    --filters 'Name=vpc-id,Values=${VPC_ID}' \
    --query 'Subnets[*].SubnetId' \
    --output text \
    --region \"$REGION\""

echo "  VPC: $VPC_ID"
echo "  Subnets: $SUBNET_IDS"

echo "aws rds create-db-subnet-group \
    --db-subnet-group-name \"${APP_NAME}-db-subnet-group\" \
    --db-subnet-group-description \"DB subnets for ${APP_NAME}\" \
    --subnet-ids $SUBNET_IDS \
    --tags Key=Name,Value=\"${APP_NAME}-db-subnet-group\" \
    --region \"$REGION\""

echo "  ✅ DB subnet group created"

# ── STEP 2: Create DB Security Group ────────────
echo ""
echo "[ STEP 2: Create RDS Security Group ]"
echo ""
echo "  DB Security Group allows access from app servers ONLY"
echo "  Port 5432 from App-Server-SG (NOT from internet)"
echo ""

DB_SG_ID="sg-demo12345"
echo "aws ec2 create-security-group \
    --group-name \"${APP_NAME}-rds-sg\" \
    --description \"RDS PostgreSQL - ${APP_NAME}\" \
    --vpc-id \"$VPC_ID\" \
    --tag-specifications \
        'ResourceType=security-group,Tags=[{Key=Name,Value=${APP_NAME}-rds-sg}]' \
    --query 'GroupId' \
    --output text \
    --region \"$REGION\""

echo "  DB Security Group: $DB_SG_ID"
echo ""
echo "  In production, allow from App-SG only:"
echo "  aws ec2 authorize-security-group-ingress \\"
echo "    --group-id $DB_SG_ID \\"
echo "    --protocol tcp \\"
echo "    --port 5432 \\"
echo "    --source-group APP_SERVER_SG_ID"
echo ""
echo "  For demo: allow from VPC CIDR"

echo "aws ec2 authorize-security-group-ingress \
    --group-id \"$DB_SG_ID\" \
    --protocol tcp \
    --port \"$DB_PORT\" \
    --cidr '10.0.0.0/8' \
    --region \"$REGION\""

echo "  ✅ Port $DB_PORT allowed from VPC CIDR"

# ── STEP 3: Store password in Secrets Manager ───
echo ""
echo "[ STEP 3: Store Password in Secrets Manager ]"
echo ""
echo "  NEVER pass passwords as plain CLI arguments"
echo "  They appear in: CloudTrail, bash history, process list"
echo ""
echo "  Use Secrets Manager:"

DB_PASSWORD=$(openssl rand -base64 16 | \
    tr -dc 'a-zA-Z0-9' | head -c 16) || \
    DB_PASSWORD="TempPass123!"

# Store in Secrets Manager
echo "aws secretsmanager create-secret \
    --name \"${APP_NAME}/rds/password\" \
    --description \"RDS password for ${APP_NAME}\" \
    --secret-string '{\"username\":\"${DB_USER}\",\"password\":\"${DB_PASSWORD}\"}' \
    --region \"$REGION\""

echo "  ✅ Password stored in Secrets Manager"

echo ""
echo "  Retrieve in application:"
echo "  aws secretsmanager get-secret-value \\"
echo "    --secret-id ${APP_NAME}/rds/password \\"
echo "    --query SecretString --output text | \\"
echo "    python3 -c \"import json,sys; d=json.load(sys.stdin); print(d['password'])\""

# ── STEP 4: Create RDS Instance ─────────────────
echo ""
echo "[ STEP 4: Create RDS PostgreSQL Instance ]"
echo ""

cat << 'EXPLAIN'
  Command breakdown:
  --db-instance-identifier: unique name for this instance
  --db-instance-class:      hardware (db.t3.micro = free tier)
  --engine:                 database engine
  --engine-version:         specific version to pin
  --master-username:        root DB user
  --master-user-password:   password (from Secrets Manager!)
  --db-name:                initial database to create
  --allocated-storage:      GB (minimum 20 for gp2/gp3)
  --storage-type:           gp3 (best price/performance)
  --storage-encrypted:      encrypt at rest (always!)
  --multi-az:               deploy standby in other AZ
  --db-subnet-group-name:   which subnets to use
  --vpc-security-group-ids: firewall rules
  --backup-retention-period: days of automated backups
  --preferred-backup-window: when to take daily backup
  --preferred-maintenance-window: when to apply patches
  --deletion-protection:    prevent accidental delete
  --enable-performance-insights: query performance data
  --publicly-accessible:    ALWAYS false for production!
EXPLAIN

echo ""
echo "  aws rds create-db-instance \\"
echo "    --db-instance-identifier $DB_IDENTIFIER \\"
echo "    --db-instance-class $DB_INSTANCE_CLASS \\"
echo "    --engine $DB_ENGINE \\"
echo "    --engine-version $DB_ENGINE_VERSION \\"
echo "    --master-username $DB_USER \\"
echo "    --master-user-password '\$SECRET' \\"
echo "    --db-name $DB_NAME \\"
echo "    --allocated-storage 20 \\"
echo "    --storage-type gp3 \\"
echo "    --storage-encrypted \\"
echo "    --multi-az \\"
echo "    --db-subnet-group-name ${APP_NAME}-db-subnet-group \\"
echo "    --vpc-security-group-ids $DB_SG_ID \\"
echo "    --backup-retention-period 7 \\"
echo "    --preferred-backup-window '03:00-04:00' \\"
echo "    --preferred-maintenance-window 'sun:04:00-sun:05:00' \\"
echo "    --deletion-protection \\"
echo "    --enable-performance-insights \\"
echo "    --no-publicly-accessible"

# Actually create for demo (single-AZ, t3.micro for cost)
echo "aws rds create-db-instance \
    --db-instance-identifier \"$DB_IDENTIFIER\" \
    --db-instance-class \"$DB_INSTANCE_CLASS\" \
    --engine \"$DB_ENGINE\" \
    --engine-version \"$DB_ENGINE_VERSION\" \
    --master-username \"$DB_USER\" \
    --master-user-password \"$DB_PASSWORD\" \
    --db-name \"$DB_NAME\" \
    --allocated-storage 20 \
    --storage-type gp3 \
    --storage-encrypted \
    --db-subnet-group-name \"${APP_NAME}-db-subnet-group\" \
    --vpc-security-group-ids \"$DB_SG_ID\" \
    --backup-retention-period 7 \
    --preferred-backup-window '03:00-04:00' \
    --preferred-maintenance-window 'sun:04:00-sun:05:00' \
    --no-deletion-protection \
    --no-publicly-accessible \
    --tags Key=Name,Value=\"${DB_IDENTIFIER}\" \
           Key=Environment,Value=learning \
           Key=Day,Value=58 \
    --region \"$REGION\""

echo ""
echo "  ✅ RDS instance creation started"

# ── STEP 5: Wait and get endpoint ───────────────
echo ""
echo "[ STEP 5: Wait for instance to be available ]"
echo ""
echo "  RDS takes 5-10 minutes to provision"
echo ""
echo "  # Wait command:"
echo "  aws rds wait db-instance-available \\"
echo "    --db-instance-identifier $DB_IDENTIFIER \\"
echo "    --region $REGION"
echo ""
echo "  # Get connection endpoint:"
echo "  aws rds describe-db-instances \\"
echo "    --db-instance-identifier $DB_IDENTIFIER \\"
echo "    --query 'DBInstances[0].Endpoint.Address' \\"
echo "    --output text"
cat > ../rds-configs/rds-config.sh << CONFIG
DB_IDENTIFIER="${DB_IDENTIFIER}"
DB_ENDPOINT="${ENDPOINT}"
DB_PORT="${DB_PORT}"
DB_NAME="${DB_NAME}"
DB_USER="${DB_USER}"
DB_SG_ID="${DB_SG_ID}"
REGION="${REGION}"
CONFIG

echo ""
echo "[ CONNECTION STRING FORMATS ]"
echo ""
echo "  PostgreSQL (psql):"
echo "  psql -h \$ENDPOINT -p 5432 -U $DB_USER -d $DB_NAME"
echo ""
echo "  Python (psycopg2):"
echo "  conn = psycopg2.connect("
echo "    host='\$ENDPOINT',"
echo "    port=5432,"
echo "    database='$DB_NAME',"
echo "    user='$DB_USER',"
echo "    password=secret_from_secretsmanager,"
echo "    sslmode='require'  # always SSL in production!"
echo "  )"
echo ""
echo "  Environment variable pattern (12-factor):"
echo "  DATABASE_URL=postgresql://user:pass@host:5432/db?sslmode=require"

echo ""
echo "[ ⚠️  CLEANUP ]"
echo "  # Disable deletion protection first:"
echo "  aws rds modify-db-instance \\"
echo "    --db-instance-identifier $DB_IDENTIFIER \\"
echo "    --no-deletion-protection \\"
echo "    --apply-immediately"
echo ""
echo "  # Delete instance (skipping final snapshot for demo):"
echo "  aws rds delete-db-instance \\"
echo "    --db-instance-identifier $DB_IDENTIFIER \\"
echo "    --skip-final-snapshot \\"
echo "    --region $REGION"
echo ""
echo "  # In production: ALWAYS take final snapshot!"
echo "  aws rds delete-db-instance \\"
echo "    --db-instance-identifier $DB_IDENTIFIER \\"
echo "    --final-db-snapshot-identifier ${DB_IDENTIFIER}-final \\"
echo "    --region $REGION"

echo ""
echo "============================================"
echo "   RDS CREATION WALKTHROUGH COMPLETE"
echo "============================================"
