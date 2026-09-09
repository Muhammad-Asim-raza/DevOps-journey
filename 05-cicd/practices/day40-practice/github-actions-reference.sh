#!/bin/bash
# ================================================
# github-actions-reference.sh
# GitHub Actions Complete Reference
# Author: Asim Raza
# Day 40 of DevOps Journey
# ================================================

echo "============================================"
echo "   GITHUB ACTIONS REFERENCE"
echo "   Author: Asim Raza - Day 40"
echo "============================================"

echo ""
echo "[ FILE LOCATION ]"
echo "  .github/workflows/name.yml"
echo "  ANY .yml file here = a workflow"
echo "  One repo can have unlimited workflows"

echo ""
echo "[ TRIGGER TYPES (on:) ]"
echo "  push:                 = on git push"
echo "  pull_request:         = on PR events"
echo "  workflow_dispatch:    = manual button"
echo "  schedule: cron: ...  = time-based"
echo "  release:             = GitHub release"
echo "  repository_dispatch: = API trigger"
echo "  workflow_call:       = called by other workflow"

echo ""
echo "[ RUNNER OPTIONS ]"
echo "  ubuntu-latest     = Ubuntu 22.04 (most used)"
echo "  macos-latest      = macOS"
echo "  windows-latest    = Windows"
echo "  self-hosted       = your own server"

echo ""
echo "[ STEP TYPES ]"
echo "  uses: action@version  = pre-built action"
echo "  run: command          = shell command"
echo "  run: |                = multi-line command"
echo "    line1"
echo "    line2"

echo ""
echo "[ KEY CONTEXTS ]"
echo "  github.event_name    = push/pull_request/etc"
echo "  github.ref_name      = branch name"
echo "  github.sha           = commit hash"
echo "  github.actor         = who triggered"
echo "  github.run_number    = build number"
echo "  runner.os            = Linux/macOS/Windows"
echo "  env.MY_VAR           = env variable"
echo "  secrets.MY_SECRET    = encrypted secret"
echo "  steps.ID.outputs.KEY = step output"
echo "  needs.JOB.outputs.KEY= job output"

echo ""
echo "[ SPECIAL FILES ]"
echo "  \$GITHUB_OUTPUT  = set step outputs"
echo "                   echo 'key=val' >> \$GITHUB_OUTPUT"
echo "  \$GITHUB_ENV     = set env vars for next steps"
echo "                   echo 'VAR=val' >> \$GITHUB_ENV"
echo "  \$GITHUB_STEP_SUMMARY = add to job summary page"
echo "                   echo '## Title' >> \$GITHUB_STEP_SUMMARY"

echo ""
echo "[ CONDITIONAL EXECUTION (if:) ]"
echo "  if: github.ref_name == 'main'"
echo "  if: github.event_name == 'push'"
echo "  if: success()"
echo "  if: failure()"
echo "  if: always()      = runs even if failed"
echo "  if: cancelled()"
echo "  if: contains(github.ref, 'main')"

echo ""
echo "[ JOB CONTROL ]"
echo "  needs: [job-a, job-b]   = sequential"
echo "  if: always()            = run even on fail"
echo "  continue-on-error: true = don't fail job"
echo "  timeout-minutes: 10     = fail after 10 min"
echo "  strategy.matrix: ...    = parallel versions"
echo "  strategy.fail-fast: false"

echo ""
echo "[ MOST USED ACTIONS ]"
echo "  actions/checkout@v4          = get code"
echo "  actions/setup-python@v4      = install Python"
echo "  actions/setup-node@v4        = install Node"
echo "  actions/cache@v3             = cache deps"
echo "  actions/upload-artifact@v3   = save files"
echo "  actions/download-artifact@v3 = get files"
echo "  docker/login-action@v3       = registry login"
echo "  docker/build-push-action@v5  = build + push"

echo ""
echo "[ WORKFLOWS CREATED TODAY ]"
ls ~/DevOps-journey/.github/workflows/*.yml \
    2>/dev/null | xargs -I{} basename {}

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
