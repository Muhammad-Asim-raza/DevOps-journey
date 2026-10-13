#!/bin/bash
# ================================================
# EC2 Launch Walkthrough - PRINT ONLY
# Author: Asim Raza - Day 56
# ================================================

REGION="ap-south-1"
APP_NAME="devops-journey"
KEY_NAME="${APP_NAME}-key"
INSTANCE_TYPE="t3.micro"

cat <<EOF
============================================
   EC2 LAUNCH WALKTHROUGH - DEMO MODE
   Author: Asim Raza - Day 56
============================================

NOTE:
This script ONLY PRINTS commands.
No AWS resources will be created.

============================================
STEP 1: CREATE SSH KEY PAIR
============================================

Purpose:
Create a key pair for SSH authentication.

Private key -> Saved on your laptop
Public key  -> Registered with AWS

COMMAND:

aws ec2 create-key-pair \\
  --key-name $KEY_NAME \\
  --key-type rsa \\
  --key-format pem \\
  --query 'KeyMaterial' \\
  --output text \\
  --region $REGION \\
  > ~/.ssh/\${KEY_NAME}.pem

chmod 400 ~/.ssh/\${KEY_NAME}.pem


============================================
STEP 2: GET AMAZON LINUX 2023 AMI
============================================

Purpose:
Find the operating system image.

COMMAND:

AMI_ID=\\$(aws ssm get-parameter \\
  --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \\
  --query 'Parameter.Value' \\
  --output text \\
  --region $REGION)

echo "\\$AMI_ID"


============================================
STEP 3: GET DEFAULT VPC
============================================

Purpose:
Find the default VPC where EC2 will launch.

COMMAND:

VPC_ID=\\$(aws ec2 describe-vpcs \\
  --filters "Name=isDefault,Values=true" \\
  --query 'Vpcs[0].VpcId' \\
  --output text \\
  --region $REGION)

echo "\\$VPC_ID"


============================================
STEP 4: GET DEFAULT SUBNET
============================================

Purpose:
Find a subnet inside the default VPC.

COMMAND:

SUBNET_ID=\\$(aws ec2 describe-subnets \\
  --filters \\
    "Name=vpc-id,Values=\\$VPC_ID" \\
    "Name=default-for-az,Values=true" \\
  --query 'Subnets[0].SubnetId' \\
  --output text \\
  --region $REGION)

echo "\\$SUBNET_ID"


============================================
STEP 5: CREATE SECURITY GROUP
============================================

Purpose:
Create a firewall for the EC2 instance.

COMMAND:

SG_ID=\\$(aws ec2 create-security-group \\
  --group-name "\${APP_NAME}-ec2-sg" \\
  --description "DevOps Journey EC2 Demo" \\
  --vpc-id "\\$VPC_ID" \\
  --query 'GroupId' \\
  --output text \\
  --region $REGION)

echo "\\$SG_ID"


============================================
STEP 6: ADD SECURITY GROUP RULES
============================================

RULE 1: SSH PORT 22

Purpose:
Allow SSH access from your public IP.

MY_IP=\\$(curl -fsS https://checkip.amazonaws.com)

aws ec2 authorize-security-group-ingress \\
  --group-id "\\$SG_ID" \\
  --protocol tcp \\
  --port 22 \\
  --cidr "\\$MY_IP/32" \\
  --region $REGION


RULE 2: HTTP PORT 80

Purpose:
Allow browser access to a website.

aws ec2 authorize-security-group-ingress \\
  --group-id "\\$SG_ID" \\
  --protocol tcp \\
  --port 80 \\
  --cidr "0.0.0.0/0" \\
  --region $REGION


RULE 3: HTTPS PORT 443

Purpose:
Allow HTTPS traffic if an HTTPS server
is configured on the instance.

aws ec2 authorize-security-group-ingress \\
  --group-id "\\$SG_ID" \\
  --protocol tcp \\
  --port 443 \\
  --cidr "0.0.0.0/0" \\
  --region $REGION


============================================
STEP 7: EC2 USER DATA
============================================

Purpose:
Automatically configure EC2 during first boot.

Create file: ec2-configs/user-data.sh

Example user data:

#!/bin/bash
set -e

dnf update -y

dnf install -y docker git python3 python3-pip

systemctl enable --now docker

usermod -aG docker ec2-user

NOTE:
These commands are only being printed.
They are NOT being executed.


============================================
STEP 8: LAUNCH EC2 INSTANCE
============================================

Purpose:
Launch EC2 using the resources created earlier.

COMMAND:

INSTANCE_ID=\\$(aws ec2 run-instances \\
  --image-id "\\$AMI_ID" \\
  --instance-type $INSTANCE_TYPE \\
  --key-name "$KEY_NAME" \\
  --security-group-ids "\\$SG_ID" \\
  --subnet-id "\\$SUBNET_ID" \\
  --associate-public-ip-address \\
  --user-data file://ec2-configs/user-data.sh \\
  --metadata-options "HttpTokens=required,HttpPutResponseHopLimit=1" \\
  --tag-specifications \\
    'ResourceType=instance,Tags=[{Key=Name,Value=devops-journey-web-server},{Key=Environment,Value=learning},{Key=Day,Value=56}]' \\
  --query 'Instances[0].InstanceId' \\
  --output text \\
  --region $REGION)

echo "\\$INSTANCE_ID"


============================================
STEP 9: WAIT FOR EC2
============================================

Purpose:
Wait until EC2 reaches running state.

COMMAND:

aws ec2 wait instance-running \\
  --instance-ids "\\$INSTANCE_ID" \\
  --region $REGION


============================================
STEP 10: GET PUBLIC IP
============================================

Purpose:
Get the public IP assigned to EC2.

COMMAND:

PUBLIC_IP=\\$(aws ec2 describe-instances \\
  --instance-ids "\\$INSTANCE_ID" \\
  --query 'Reservations[0].Instances[0].PublicIpAddress' \\
  --output text \\
  --region $REGION)

echo "\\$PUBLIC_IP"


============================================
STEP 11: CONNECT USING SSH
============================================

COMMAND:

ssh -i ~/.ssh/$KEY_NAME.pem ec2-user@\\$PUBLIC_IP


============================================
STEP 12: TEST WEBSITE
============================================

COMMAND:

curl http://\\$PUBLIC_IP

Or open in browser:

http://\\$PUBLIC_IP

NOTE:
A web server must actually be running on
port 80 for this test to work.


============================================
STEP 13: CLEANUP
============================================

Terminate EC2:

aws ec2 terminate-instances \\
  --instance-ids "\\$INSTANCE_ID" \\
  --region $REGION

Wait for termination:

aws ec2 wait instance-terminated \\
  --instance-ids "\\$INSTANCE_ID" \\
  --region $REGION

Delete security group:

aws ec2 delete-security-group \\
  --group-id "\\$SG_ID" \\
  --region $REGION

Delete AWS key pair:

aws ec2 delete-key-pair \\
  --key-name "$KEY_NAME" \\
  --region $REGION

Delete local private key:

rm ~/.ssh/$KEY_NAME.pem


============================================
       WALKTHROUGH COMPLETE
============================================

IMPORTANT:
All commands above were PRINTED ONLY.

No EC2 instance was launched.
No security group was created.
No AWS key pair was created.
No AWS API calls were made.

============================================
EOF
