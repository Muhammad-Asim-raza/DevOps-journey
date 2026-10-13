#!/bin/bash
# ================================================
# 04-ec2-lifecycle.sh
# EC2 Instance Lifecycle and Management
# Author: Asim Raza - Day 56
# ================================================

REGION="${AWS_DEFAULT_REGION:-us-east-1}"

echo "============================================"
echo "   EC2 INSTANCE LIFECYCLE"
echo "============================================"

echo ""
echo "[ EC2 INSTANCE STATES ]"
cat << 'DIAGRAM'

  PENDING → RUNNING → STOPPING → STOPPED → TERMINATED
     ↑                                          ↑
  run-instances                         terminate-instances
                 ↓                          ↑
              stop-instances          start-instances
                                (from STOPPED state)

States:
  pending:    Starting up, billing starts
  running:    Active, fully billed
  stopping:   Shutting down (not billed)
  stopped:    Off (EBS still billed, CPU/RAM NOT billed)
  terminated: DELETED permanently (cannot recover!)
  rebooting:  Restart (stays running, brief downtime)

KEY: stopped ≠ terminated
  stopped: OFF but recoverable (like hibernate)
  terminated: GONE FOREVER (like thrown in trash)
DIAGRAM

echo ""
echo "[ LIFECYCLE COMMANDS ]"
echo ""
echo "  # Start stopped instance:"
echo "  aws ec2 start-instances --instance-ids i-xxx"
echo ""
echo "  # Stop running instance (graceful shutdown):"
echo "  aws ec2 stop-instances --instance-ids i-xxx"
echo ""
echo "  # Reboot instance:"
echo "  aws ec2 reboot-instances --instance-ids i-xxx"
echo ""
echo "  # TERMINATE (DELETE FOREVER):"
echo "  aws ec2 terminate-instances --instance-ids i-xxx"
echo ""
echo "  # Force stop (if stuck):"
echo "  aws ec2 stop-instances --instance-ids i-xxx --force"

echo ""
echo "[ DESCRIBE INSTANCES (most used command) ]"
echo ""
echo "  # List all your instances:"
echo "  aws ec2 describe-instances \\"
echo "    --query 'Reservations[*].Instances[*].[\\"
echo "      InstanceId,\\"
echo "      State.Name,\\"
echo "      InstanceType,\\"
echo "      PublicIpAddress,\\"
echo "      Tags[?Key==\`Name\`].Value|[0]\\"
echo "    ]' \\"
echo "    --output table"
echo ""
echo "  # Filter by state:"
echo "  aws ec2 describe-instances \\"
echo "    --filters 'Name=instance-state-name,Values=running' \\"
echo "    --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress]' \\"
echo "    --output table"
echo ""
echo "  # Filter by tag:"
echo "  aws ec2 describe-instances \\"
echo "    --filters 'Name=tag:Environment,Values=production' \\"
echo "    --output table"

if command -v aws &>/dev/null; then
    echo ""
    echo "  [ Live: Your EC2 Instances ]"
    aws ec2 describe-instances \
        --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PublicIpAddress,Tags[?Key==`Name`].Value|[0]]' \
        --output table \
        --region "$REGION" 2>/dev/null || \
        echo "  (configure credentials to see instances)"
fi

echo ""
echo "[ EBS STORAGE CONCEPTS ]"
echo ""
echo "  EBS (Elastic Block Store) = persistent disk"
echo "  Like a hard drive for your EC2"
echo ""
echo "  EBS Volume Types:"
echo "  gp3: General Purpose SSD (default, best value)"
echo "       3,000 IOPS baseline, 125 MB/s throughput"
echo "       \$0.08/GB/month"
echo ""
echo "  gp2: General Purpose SSD (older, avoid for new)"
echo "       Burst IOPS, more expensive"
echo ""
echo "  io2: Provisioned IOPS SSD (databases)"
echo "       Up to 64,000 IOPS, consistent performance"
echo "       Use: Oracle, SQL Server, high-traffic MySQL"
echo ""
echo "  st1: Throughput Optimized HDD"
echo "       Cheap, sequential reads (big data, logs)"
echo ""
echo "  sc1: Cold HDD (cheapest)"
echo "       Infrequent access, archive"
echo ""
echo "  ROOT VOLUME best practices:"
echo "  - Use gp3 (better performance, cheaper)"
echo "  - Enable encryption: at rest encryption"
echo "  - DeleteOnTermination: true (default, clean up)"
echo "  - Snapshot before changes"

echo ""
echo "[ EC2 CONNECT METHODS ]"
echo ""
echo "  1. SSH (traditional):"
echo "  ssh -i ~/.ssh/my-key.pem ec2-user@PUBLIC_IP"
echo "  (ec2-user for Amazon Linux, ubuntu for Ubuntu)"
echo ""
echo "  2. EC2 Instance Connect (browser):"
echo "  AWS Console → EC2 → Instance → Connect"
echo "  No key pair needed (temporary key)"
echo "  Instance must have public IP"
echo ""
echo "  3. SSM Session Manager (BEST for production):"
echo "  aws ssm start-session --target i-xxx"
echo "  No SSH port (22) needed!"
echo "  No key pair needed!"
echo "  Works on private instances (no public IP)"
echo "  Full audit logging to CloudTrail"
echo "  Requires: SSM Agent (pre-installed on AL2023)"
echo "            IAM role with AmazonSSMManagedInstanceCore"
echo ""
echo "  SSM is preferred because:"
echo "  ✅ No SSH port open = smaller attack surface"
echo "  ✅ No key pair management"
echo "  ✅ Works on private instances"
echo "  ✅ All commands logged"
echo "  ✅ Can be locked down with IAM"

echo ""
echo "[ ELASTIC IP (Static Public IP) ]"
echo ""
echo "  Problem: EC2 gets NEW public IP on every start/stop"
echo "  Solution: Elastic IP = static public IP"
echo ""
echo "  # Allocate Elastic IP:"
echo "  aws ec2 allocate-address --domain vpc"
echo ""
echo "  # Associate with instance:"
echo "  aws ec2 associate-address \\"
echo "    --instance-id i-xxx \\"
echo "    --allocation-id eipalloc-xxx"
echo ""
echo "  # Dissociate:"
echo "  aws ec2 disassociate-address --association-id eipassoc-xxx"
echo ""
echo "  # Release (MUST release or billed!):"
echo "  aws ec2 release-address --allocation-id eipalloc-xxx"
echo ""
echo "  Cost: FREE when attached to running instance"
echo "        \$0.005/hour when NOT attached (wasted IP)"
echo "        Always release unattached EIPs!"

echo ""
echo "[ SSH TROUBLESHOOTING ]"
echo ""
echo "  Issue 1: Permission denied (publickey)"
echo "  Cause:   Wrong key, wrong user, wrong permissions"
echo "  Fix:     chmod 400 key.pem"
echo "           ec2-user (AL2023), ubuntu (Ubuntu)"
echo "           verify key pair matches instance"
echo ""
echo "  Issue 2: Connection timeout"
echo "  Cause:   Security group blocking port 22"
echo "           Wrong IP in security group"
echo "  Fix:     Check SG: port 22 from YOUR IP/32"
echo "           Your IP may have changed!"
echo ""
echo "  Issue 3: Host key verification failed"
echo "  Cause:   Instance was replaced, same IP"
echo "  Fix:     ssh-keygen -R INSTANCE_IP"
echo ""
echo "  Issue 4: REMOTE HOST IDENTIFICATION HAS CHANGED"
echo "  Same as #3 - remove old host key"

echo ""
echo "============================================"
echo "   EC2 LIFECYCLE REFERENCE COMPLETE"
echo "============================================"
