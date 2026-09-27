#!/bin/bash
# ================================================
# gitlab-ci-reference.sh
# GitLab CI Complete Reference
# Author: Asim Raza - Day 48
# ================================================

echo "============================================"
echo "   GITLAB CI REFERENCE"
echo "   Author: Asim Raza - Day 48"
echo "============================================"

echo ""
echo "[ GITLAB CI vs GITHUB ACTIONS vs JENKINS ]"
printf "%-25s %-20s %-20s %-20s\n" \
    "Feature" "GitLab CI" "GitHub Actions" "Jenkins"
printf "%-25s %-20s %-20s %-20s\n" \
    "-------" "---------" "--------------" "-------"
printf "%-25s %-20s %-20s %-20s\n" \
    "Config file" ".gitlab-ci.yml" ".github/workflows/" "Jenkinsfile"
printf "%-25s %-20s %-20s %-20s\n" \
    "Language" "YAML" "YAML" "Groovy"
printf "%-25s %-20s %-20s %-20s\n" \
    "Container Registry" "Built-in" "GHCR" "Plugin"
printf "%-25s %-20s %-20s %-20s\n" \
    "MR/PR checks" "Native" "Native" "Plugin"
printf "%-25s %-20s %-20s %-20s\n" \
    "Hosting" "Self/Cloud" "Cloud" "Self-hosted"
printf "%-25s %-20s %-20s %-20s\n" \
    "Free CI minutes" "400/month" "2000/month" "Your server"

echo ""
echo "[ .gitlab-ci.yml STRUCTURE ]"
cat << 'EOF'
image: python:3.11-slim    # Default image for all jobs
stages: [test, build, deploy]

variables:                  # Pipeline-level variables
  APP_NAME: myapp

cache:                      # Share between runs
  key: $CI_COMMIT_REF_SLUG
  paths: [.cache/pip]

before_script:             # Runs before every job script
  - pip install --quiet -r requirements.txt

job-name:
  stage: test              # Which stage
  image: python:3.10       # Override image
  needs: [other-job]       # Depends on this job
  rules:                   # When to run
    - if: '$CI_COMMIT_BRANCH == "main"'
  variables:               # Job-level variables
    JOB_VAR: value
  script:                  # Commands to run
    - pytest tests/
  artifacts:               # Files to keep/pass
    paths: [junit.xml]
    reports:
      junit: junit.xml
    expire_in: 1 week
  environment:             # Track deployments
    name: staging
    url: https://staging.example.com
  when: manual             # Require human click
  allow_failure: true      # Don't block pipeline
EOF

echo ""
echo "[ STAGE EXECUTION ]"
echo "  Jobs in SAME stage: run in PARALLEL"
echo "  Stages: run in SEQUENTIAL order"
echo "  Example:"
echo "  Stage 1 (test): unit-tests || lint || security"
echo "                  (all three at same time)"
echo "  Stage 2 (build): build-image"
echo "                  (waits for all test stage jobs)"

echo ""
echo "[ RULES CHEAT SHEET ]"
echo "  # Always run:"
echo "  rules: [{when: always}]"
echo ""
echo "  # Main branch only:"
echo "  rules:"
echo "    - if: '\$CI_COMMIT_BRANCH == \"main\"'"
echo ""
echo "  # Merge requests:"
echo "  rules:"
echo "    - if: '\$CI_PIPELINE_SOURCE == \"merge_request_event\"'"
echo ""
echo "  # File changes:"
echo "  rules:"
echo "    - changes: [\"**/*.py\", \"requirements.txt\"]"
echo ""
echo "  # Not on main (exclude):"
echo "  rules:"
echo "    - if: '\$CI_COMMIT_BRANCH == \"main\"'"
echo "      when: never"
echo "    - when: always"

echo ""
echo "[ KEY GITLAB CI VARIABLES ]"
echo "  CI_PROJECT_NAME      = repo name"
echo "  CI_COMMIT_SHA        = full commit SHA"
echo "  CI_COMMIT_SHORT_SHA  = 8-char SHA"
echo "  CI_COMMIT_BRANCH     = branch name"
echo "  CI_PIPELINE_ID       = unique pipeline ID"
echo "  CI_PIPELINE_IID      = incremental pipeline #"
echo "  CI_JOB_NAME          = current job name"
echo "  CI_REGISTRY          = registry.gitlab.com"
echo "  CI_REGISTRY_IMAGE    = project registry URL"
echo "  CI_REGISTRY_USER     = auto login user"
echo "  CI_REGISTRY_PASSWORD = auto job token"
echo "  CI_PIPELINE_SOURCE   = push|merge_request_event|schedule"
echo "  CI_MERGE_REQUEST_IID = MR number (in MR pipeline)"

echo ""
echo "[ FILES CREATED TODAY ]"
ls ~/DevOps-journey/05-cicd/practices/day48-practice/gitlab-configs/

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
