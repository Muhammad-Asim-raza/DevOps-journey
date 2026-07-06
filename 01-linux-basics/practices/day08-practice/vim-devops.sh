#!/bin/bash
# ================================================
# vim-devops.sh
# Vim in Real DevOps Scenarios
# Author: Asim Raza
# Day 8 of DevOps Journey
# ================================================

echo "============================================"
echo "   VIM REAL DEVOPS SCENARIOS"
echo "============================================"

echo ""
echo "[ SCENARIO 1: Edit nginx config ]"
echo "  Real command: vim /etc/nginx/nginx.conf"
echo "  Common tasks:"
echo "  - Change server_name"
echo "  - Update proxy_pass IP"
echo "  - Modify listen port"
echo "  Commands used:"
echo "  /server_name     = find server_name"
echo "  cw               = change word"
echo "  :%s/old-ip/new-ip/g = replace IP"
echo "  :wq              = save and exit"

echo ""
echo "[ SCENARIO 2: Edit SSH config ]"
echo "  Real command: sudo vim /etc/ssh/sshd_config"
echo "  Common tasks:"
echo "  - Disable root login"
echo "  - Change SSH port"
echo "  - Add allowed users"
echo "  Commands used:"
echo "  /PermitRootLogin = find the setting"
echo "  cw               = change the value"
echo "  :wq              = save"
echo "  sudo systemctl restart ssh = apply"

echo ""
echo "[ SCENARIO 3: Edit Kubernetes manifest ]"
echo "  Real command: vim deployment.yaml"
echo "  Common tasks:"
echo "  - Update image version"
echo "  - Change replica count"
echo "  - Update environment variables"
echo "  Commands used:"
echo "  :%s/image:v1/image:v2/g = update version"
echo "  /replicas        = find replicas"
echo "  cw               = change value"

echo ""
echo "[ SCENARIO 4: Quick server fix ]"
echo "  vim /etc/hosts"
echo "  Add IP to hostname mapping"
echo "  G = go to end of file"
echo "  o = new line below and insert"
echo "  Type: 192.168.1.100 myserver.local"
echo "  Escape + :wq = save"

echo ""
echo "============================================"
echo "   DEVOPS SCENARIOS COMPLETE"
echo "============================================"
