#!/bin/bash
# ================================================
# 03-instance-metadata.sh
# EC2 Instance Metadata Service (IMDS)
# Author: Asim Raza - Day 56
# PRINT ONLY - NO AWS COMMANDS EXECUTED
# ================================================

cat <<'REFERENCE'

============================================
   EC2 INSTANCE METADATA SERVICE (IMDS)
   How Instances Learn About Themselves
============================================

MODE: PRINT ONLY

No AWS API calls or metadata requests
will be executed by this script.


============================================
1. WHAT IS IMDS?
============================================

IMDS = Instance Metadata Service

Metadata endpoint:
http://169.254.169.254

169.254.169.254 is a link-local address.

It is normally accessible from inside
the EC2 instance, subject to metadata
settings and network configuration.

IMDS provides information such as:

- Instance ID
- Instance type
- AWS Region
- Availability Zone
- Public IP (if assigned)
- Private IP
- AMI ID
- IAM role credentials (if role attached)
- User data (if supplied)
- Security group information

WHY DO WE NEED IT?

Applications running on EC2 can discover
information about their own instance.

AWS SDKs can also obtain temporary
IAM role credentials automatically.


============================================
2. IMDSv1 VS IMDSv2
============================================

IMDSv1:
- Uses simple HTTP GET requests
- Does not require a session token
- More vulnerable to certain SSRF attacks

IMDSv2:
- Requires a session token
- Token is obtained using HTTP PUT
- Subsequent requests include the token
- Provides additional SSRF protections

RECOMMENDATION:

Use IMDSv2 with:

HttpTokens=required

IMPORTANT:
IMDSv2 improves security but does not
prevent every possible SSRF attack.


============================================
3. GET IMDSv2 TOKEN
============================================

Run these commands INSIDE an EC2 instance.

STEP 1: Request a session token

TOKEN=$(curl -fsS -X PUT \
  "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

Explanation:

- curl sends an HTTP request
- -X PUT selects the PUT method
- The header requests a token lifetime
- 21600 seconds = 6 hours
- TOKEN stores the returned session token

IMPORTANT:

Do not print or share the token unnecessarily.


============================================
4. GET INSTANCE ID
============================================

COMMAND:

curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id

Example output:

i-0123456789abcdef0

This identifies the EC2 instance.


============================================
5. GET INSTANCE TYPE
============================================

COMMAND:

curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-type

Example output:

t3.micro

This identifies the EC2 instance size.


============================================
6. GET PUBLIC IP ADDRESS
============================================

COMMAND:

curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4

Example output:

203.0.113.25

NOTE:
If the instance has no public IPv4 address,
this metadata field may not exist.


============================================
7. GET PRIVATE IP ADDRESS
============================================

COMMAND:

curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4

Example output:

10.0.1.42

This is the primary private IPv4 address.


============================================
8. GET AVAILABILITY ZONE
============================================

COMMAND:

curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone

Example output:

us-east-1a


============================================
9. GET AWS REGION
============================================

COMMAND:

curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/region

Example output:

us-east-1


============================================
10. GET AMI ID
============================================

COMMAND:

curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/ami-id

Example output:

ami-0123456789abcdef0


============================================
11. GET IAM ROLE NAME
============================================

COMMAND:

curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/iam/security-credentials/

Example output:

my-ec2-role

IMPORTANT:
An IAM role must be attached to EC2
through an instance profile.

Otherwise this information is unavailable.


============================================
12. IAM ROLE CREDENTIALS
============================================

IMDS can provide temporary AWS credentials
for the IAM role attached to the instance.

Credential endpoint:

http://169.254.169.254/latest/meta-data/iam/security-credentials/ROLE_NAME

The response contains sensitive values:

- AccessKeyId
- SecretAccessKey
- Token
- Expiration

Do not print these credentials or
include them in application logs.

AWS SDKs normally retrieve and refresh
these credentials automatically.


============================================
13. VIEW USER DATA
============================================

COMMAND:

curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/user-data

This retrieves the user data supplied
when the instance was launched.

If no user data was supplied, this
endpoint may return no content or 404.

Never store passwords or secrets in
EC2 user data.


============================================
14. LIST METADATA PATHS
============================================

COMMAND:

curl -fsS \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/

This lists available metadata categories.


============================================
15. HOW BOTO3 USES IMDS
============================================

Example Python code:

import boto3

s3 = boto3.client("s3")

response = s3.list_buckets()

print(response["Buckets"])

WHAT HAPPENS?

1. Python application starts.

2. boto3 searches its credential
   provider chain.

3. If earlier credential sources do not
   provide credentials, boto3 can use
   the EC2 instance profile.

4. boto3 obtains temporary credentials
   through IMDS.

5. boto3 signs the S3 API request.

6. AWS checks the IAM permissions.

7. AWS returns the result if permitted.

8. boto3 refreshes temporary credentials
   automatically when needed.

IMPORTANT:

The instance role must have the
required S3 permissions.

No permanent AWS access keys need
to be stored in your Python code.


============================================
16. ENFORCE IMDSv2 WHEN LAUNCHING EC2
============================================

COMMAND:

aws ec2 run-instances \
  --image-id ami-EXAMPLE \
  --instance-type t3.micro \
  --metadata-options \
    "HttpTokens=required,HttpPutResponseHopLimit=1" \
  --region ap-south-1

NOTE:
This is an illustrative command.
A valid AMI and other launch settings
may be required.

EXPLANATION:

HttpTokens=required

- Requires IMDSv2 tokens
- Disables tokenless IMDSv1 requests

HttpPutResponseHopLimit=1

- Sets the IP hop limit on IMDSv2
  token responses
- May prevent containers in certain
  network configurations from receiving
  token responses

For containerized workloads, the
appropriate hop limit depends on the
network architecture.


============================================
17. CHECK METADATA SETTINGS
============================================

COMMAND:

aws ec2 describe-instances \
  --instance-ids i-EXAMPLE \
  --query \
    'Reservations[0].Instances[0].MetadataOptions' \
  --region ap-south-1

Example output:

{
  "HttpTokens": "required",
  "HttpPutResponseHopLimit": 1,
  "HttpEndpoint": "enabled"
}

Replace i-EXAMPLE with a real instance ID.


============================================
18. COMPLETE IMDS WORKFLOW
============================================

EC2 Instance
      |
      v
Application / AWS SDK
      |
      v
IMDS Endpoint
169.254.169.254
      |
      | HTTP PUT
      v
Receive IMDSv2 Token
      |
      | HTTP GET + Token
      v
Retrieve Instance Metadata
      |
      +-- Instance ID
      |
      +-- Instance Type
      |
      +-- Region / AZ
      |
      +-- Private IP
      |
      +-- AMI ID
      |
      +-- IAM Role Credentials
             |
             v
      AWS SDK Signs API Request
             |
             v
      AWS Service Checks IAM
             |
             v
      Request Allowed or Denied


============================================
   IMDS REFERENCE COMPLETE
============================================

ALL COMMANDS ABOVE WERE PRINTED ONLY.

No AWS commands were executed.
No curl requests were made.
No metadata tokens were requested.
No credentials were retrieved.
No EC2 resources were created.

============================================

REFERENCE
