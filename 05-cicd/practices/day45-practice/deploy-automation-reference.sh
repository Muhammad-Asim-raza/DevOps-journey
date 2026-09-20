#!/bin/bash
# ================================================
# deploy-automation-reference.sh
# Deploy Automation Complete Reference
# Author: Asim Raza - Day 45
# ================================================

echo "============================================"
echo "   DEPLOY AUTOMATION REFERENCE"
echo "   Author: Asim Raza - Day 45"
echo "============================================"

echo ""
echo "[ DEPLOYMENT STRATEGIES ]"
echo ""
echo "  Recreate:    stop old → deploy new → start"
echo "               Downtime: YES"
echo "               Use: dev environments"
echo ""
echo "  Rolling:     update 1 instance at a time"
echo "               Downtime: NO"
echo "               Rollback: slow"
echo "               Use: stateless APIs"
echo ""
echo "  Blue-Green:  deploy to idle env, switch"
echo "               Downtime: NO"
echo "               Rollback: instant (switch back)"
echo "               Use: critical services"
echo ""
echo "  Canary:      5% → monitor → 100%"
echo "               Downtime: NO"
echo "               Rollback: instant (0% traffic)"
echo "               Use: high-risk changes"

echo ""
echo "[ SSH DEPLOYMENT PATTERN ]"
echo "  uses: appleboy/ssh-action@master"
echo "  with:"
echo "    host: \${{ secrets.PROD_HOST }}"
echo "    username: \${{ secrets.PROD_USER }}"
echo "    key: \${{ secrets.PROD_SSH_KEY }}"
echo "    script: |"
echo "      docker pull \$IMAGE"
echo "      docker-compose up -d --no-deps app"

echo ""
echo "[ HEALTH CHECK PATTERN ]"
echo "  MAX_WAIT=60"
echo "  ELAPSED=0"
echo "  while [ \$ELAPSED -lt \$MAX_WAIT ]; do"
echo "    HTTP=\$(curl -s -o /dev/null -w '%{http_code}' /health)"
echo "    [ \$HTTP = '200' ] && break"
echo "    sleep 5; ELAPSED=\$((ELAPSED+5))"
echo "  done"

echo ""
echo "[ ROLLBACK PATTERN ]"
echo "  Save current image before deploying:"
echo "  ROLLBACK_TAG=\$(docker inspect app --format '{{.Config.Image}}')"
echo ""
echo "  On failure:"
echo "  docker rm -f app"
echo "  docker run -d --name app \$ROLLBACK_TAG"

echo ""
echo "[ SLACK NOTIFICATION ]"
echo "  curl -X POST \${{ secrets.SLACK_WEBHOOK }} \\"
echo "    -H 'Content-type: application/json' \\"
echo "    --data '{"
echo '      "text": "✅ Production deployed v1.0.42"'
echo "    }'"

echo ""
echo "[ ENVIRONMENT PROMOTION ]"
echo "  feature/ branch → (merge) → main"
echo "  main → auto-deploy to staging"
echo "  staging → (approval) → production"
echo ""
echo "  Concurrency:"
echo "  staging: cancel-in-progress: false"
echo "  production: cancel-in-progress: false"
echo "  (never cancel deployments mid-flight)"

echo ""
echo "[ SECRETS NEEDED FOR REAL DEPLOYMENT ]"
echo "  SSH_PRIVATE_KEY   = server SSH key"
echo "  SSH_HOST          = server IP/hostname"
echo "  SSH_USER          = deploy username"
echo "  SLACK_WEBHOOK_URL = Slack webhook"
echo "  DOCKERHUB_TOKEN   = registry push"
echo "  (use GITHUB_TOKEN for GHCR)"

echo ""
echo "[ WORKFLOWS CREATED TODAY ]"
for wf in 24 25 26 27; do
    ls ~/DevOps-journey/.github/workflows/${wf}-*.yml \
        2>/dev/null | xargs -I{} basename {}
done

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
