#!/bin/bash
# ================================================
# cfn-reference.sh
# CloudFormation Complete Reference
# Author: Asim Raza - Day 61
# ================================================

echo "============================================"
echo "   AWS CLOUDFORMATION REFERENCE"
echo "   Author: Asim Raza - Day 61"
echo "============================================"

echo ""
echo "[ TEMPLATE SECTIONS ]"
echo "  AWSTemplateFormatVersion: '2010-09-09' (required)"
echo "  Description: text"
echo "  Parameters: inputs"
echo "  Mappings: lookup tables"
echo "  Conditions: boolean expressions"
echo "  Resources: ONLY REQUIRED SECTION"
echo "  Outputs: export values"

echo ""
echo "[ INTRINSIC FUNCTIONS ]"
echo "  !Ref X          → value/physical-ID"
echo "  !Sub 'text'     → string substitution"
echo "  !GetAtt R.Attr  → resource attribute"
echo "  !FindInMap [M,K,V] → mapping lookup"
echo "  !If [C,T,F]     → conditional"
echo "  !Select [i,list] → list item"
echo "  !GetAZs ''       → AZ list"
echo "  !ImportValue N   → cross-stack reference"
echo "  !Join [d,list]   → join strings"
echo "  !Base64 str      → base64 encode"
echo "  !Cidr [r,c,b]    → generate CIDRs"

echo ""
echo "[ KEY CLI COMMANDS ]"
echo "  aws cloudformation validate-template"
echo "  aws cloudformation deploy (create or update)"
echo "  aws cloudformation create-change-set"
echo "  aws cloudformation describe-change-set"
echo "  aws cloudformation execute-change-set"
echo "  aws cloudformation detect-stack-drift"
echo "  aws cloudformation describe-stacks"
echo "  aws cloudformation list-stacks"
echo "  aws cloudformation delete-stack"
echo "  aws cloudformation update-termination-protection"

echo ""
echo "[ CFN vs TERRAFORM ]"
echo "  CloudFormation: AWS-only, auto-rollback, free, AWS support"
echo "  Terraform:      multi-cloud, HCL, state file, huge community"
echo "  Both: IaC, version-controlled, reproducible"

echo ""
echo "[ DELETION POLICIES ]"
echo "  Delete:   removed when stack deleted (default)"
echo "  Retain:   kept after stack deleted (S3 with data)"
echo "  Snapshot: snapshot taken then deleted (RDS, EBS)"

echo ""
echo "[ STACK STATUSES ]"
echo "  CREATE_COMPLETE   update_COMPLETE → success"
echo "  *_FAILED          *_ROLLBACK_*   → failure"
echo "  DELETE_FAILED → resource blocking deletion"

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
