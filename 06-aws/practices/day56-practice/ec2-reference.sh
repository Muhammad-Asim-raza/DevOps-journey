#!/bin/bash
# ================================================
# ec2-reference.sh
# EC2 Complete Reference
# Author: Asim Raza - Day 56
# ================================================

echo "============================================"
echo "   AWS EC2 COMPLETE REFERENCE"
echo "   Author: Asim Raza - Day 56"
echo "============================================"

echo ""
echo "[ INSTANCE FAMILIES ]"
echo "  t3/t4g  Burstable General Purpose  (cheap, dev/test)"
echo "  m6i/m7i Balanced (web/app servers)"
echo "  c6i/c7g Compute optimized (CPU-heavy)"
echo "  r6i/r7g Memory optimized (databases, Redis)"
echo "  i4i     Storage optimized (I/O intensive)"
echo "  p4d/p5  GPU (ML training)"

echo ""
echo "[ LAUNCH COMMAND ]"
echo "  aws ec2 run-instances \\"
echo "    --image-id ami-xxxxxxxxx \\"
echo "    --instance-type t3.micro \\"
echo "    --key-name my-key \\"
echo "    --security-group-ids sg-xxx \\"
echo "    --subnet-id subnet-xxx \\"
echo "    --associate-public-ip-address \\"
echo "    --user-data file://setup.sh \\"
echo "    --metadata-options HttpTokens=required \\"
echo "    --block-device-mappings '[{\"DeviceName\":\"/dev/xvda\",\"Ebs\":{\"VolumeSize\":20,\"VolumeType\":\"gp3\",\"Encrypted\":true}}]' \\"
echo "    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=my-server}]'"

echo ""
echo "[ KEY LIFECYCLE COMMANDS ]"
echo "  aws ec2 start-instances    --instance-ids i-xxx"
echo "  aws ec2 stop-instances     --instance-ids i-xxx"
echo "  aws ec2 reboot-instances   --instance-ids i-xxx"
echo "  aws ec2 terminate-instances --instance-ids i-xxx ← DELETES!"
echo "  aws ec2 describe-instances --filters 'Name=instance-state-name,Values=running'"

echo ""
echo "[ SSH AND CONNECT ]"
echo "  ssh -i ~/.ssh/key.pem ec2-user@PUBLIC_IP  (Amazon Linux)"
echo "  ssh -i ~/.ssh/key.pem ubuntu@PUBLIC_IP     (Ubuntu)"
echo "  aws ssm start-session --target i-xxx       (SSM - PREFERRED)"

echo ""
echo "[ USER DATA ]"
echo "  Runs ONCE on first boot as root"
echo "  Logs: /var/log/cloud-init-output.log"
echo "  Pass: --user-data file://userdata.sh"

echo ""
echo "[ IMDS (METADATA) ]"
echo "  Only from inside instance: http://169.254.169.254"
echo "  IMDSv2: needs PUT token first"
echo "  Gets: instance-id, type, IP, role credentials"
echo "  AWS SDK uses automatically for IAM role creds"

echo ""
echo "[ EBS VOLUMES ]"
echo "  gp3: \$0.08/GB - use this for most cases"
echo "  io2: provisioned IOPS for databases"
echo "  Encrypted: always encrypt root volume"
echo "  DeleteOnTermination: true (auto cleanup)"

echo ""
echo "[ ELASTIC IP ]"
echo "  Free when attached to running instance"
echo "  \$0.005/hr when not attached"
echo "  ALWAYS release when done!"

echo ""
echo "============================================"
echo "   EC2 REFERENCE COMPLETE"
echo "============================================"
