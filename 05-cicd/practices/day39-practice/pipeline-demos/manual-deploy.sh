#!/bin/bash
# ================================================
# manual-deploy.sh
# Simulates MANUAL deployment (the old painful way)
# Author: Asim Raza - Day 39
# This is what we REPLACED with CI/CD
# ================================================

echo "============================================"
echo "  MANUAL DEPLOYMENT (The Old Way)"
echo "  Notice: error-prone, slow, stressful"
echo "============================================"

APP_DIR="/tmp/manual-deploy-demo"
mkdir -p $APP_DIR

echo ""
echo "[ STEP 1: Developer announces deployment ]"
echo "  Ahmad: 'Hey Bilal, I'm ready to deploy'"
echo "  Bilal: 'OK, let me clear my Friday evening'"
echo "  Time lost: 2 days waiting for coordination"
sleep 1

echo ""
echo "[ STEP 2: Connect to server ]"
echo "  ssh bilal@production-server.company.com"
echo "  Password: ..."
echo "  MFA code: ..."
echo "  Connected (if VPN works)"
sleep 1

echo ""
echo "[ STEP 3: Manual pre-deployment checklist ]"
echo "  Bilal manually checking:"
echo "  - Is backup done? (forgot!)"
echo "  - Is staging tested? (partially)"
echo "  - Is rollback plan ready? (in my head)"
echo "  - Is team notified? (Slack message sent)"
sleep 1

echo ""
echo "[ STEP 4: Stop application ]"
echo "  systemctl stop myapp"
echo "  DOWNTIME BEGINS NOW"
echo "  Users see: 502 Bad Gateway"
sleep 1

echo ""
echo "[ STEP 5: Pull new code ]"
echo "  git pull origin main"
echo "  Merge conflict in config.py!"
echo "  Bilal: 'Ahmad, there's a conflict...'"
echo "  Ahmad: 'Just take mine'"
echo "  Risk: may break something"
sleep 1

echo ""
echo "[ STEP 6: Install dependencies ]"
echo "  pip install -r requirements.txt"
echo "  Downloading..."
echo "  Downloading..."
echo "  Error: package version conflict!"
echo "  pip install --force-reinstall..."
echo "  (5 minutes of anxiety)"
sleep 1

echo ""
echo "[ STEP 7: Run migrations ]"
echo "  python manage.py migrate"
echo "  Running migration 0042..."
echo "  Success? (Bilal: I think so)"
echo "  (No automated verification)"
sleep 1

echo ""
echo "[ STEP 8: Restart application ]"
echo "  systemctl start myapp"
echo "  Is it running? systemctl status myapp"
echo "  Green? Deploy complete!"
echo "  DOWNTIME ENDS (if everything worked)"
sleep 1

echo ""
echo "[ STEP 9: Smoke test (manual) ]"
echo "  Bilal opens browser"
echo "  Clicks around homepage"
echo "  'Seems to work?'"
echo "  Goes to bed at 2am"
sleep 1

echo ""
echo "[ STEP 10: 3am - Production down ]"
echo "  PagerDuty fires"
echo "  'Database migration left table in bad state'"
echo "  Bilal woken up"
echo "  Manual rollback in panicked state"
echo "  45 minutes of downtime"
echo "  Revenue lost: thousands of dollars"

echo ""
echo "============================================"
echo "  TOTAL TIME FOR MANUAL DEPLOYMENT:"
echo "  Planning:      2 days"
echo "  Deployment:    45 minutes"
echo "  Downtime:      10-45 minutes"
echo "  Recovery risk: HIGH"
echo "  Team stress:   EXTREME"
echo "============================================"
