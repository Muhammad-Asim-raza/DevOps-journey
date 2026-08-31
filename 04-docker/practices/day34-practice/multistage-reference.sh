#!/bin/bash
# ================================================
# multistage-reference.sh
# Multi-Stage Build Complete Reference
# Author: Asim Raza
# Day 34 of DevOps Journey
# ================================================

echo "============================================"
echo "   MULTI-STAGE BUILD REFERENCE"
echo "   Author: Asim Raza - Day 34"
echo "============================================"

echo ""
echo "[ WHAT IS MULTI-STAGE BUILD ]"
echo "  Use multiple FROM instructions in one Dockerfile"
echo "  Each FROM = new stage (clean environment)"
echo "  COPY --from=stagename = copy between stages"
echo "  Only LAST stage goes into final image"
echo "  Earlier stages are temporary (discarded)"

echo ""
echo "[ SYNTAX ]"
cat << 'EOF'
# Named stage
FROM image AS stage-name

# Build something in this stage
RUN build-commands...

# Final stage
FROM minimal-image AS production

# Copy ONLY what you need from build stage
COPY --from=stage-name /built/artifact /app/

# Nothing else from stage-name is in final image!
EOF

echo ""
echo "[ STAGE NAMING CONVENTIONS ]"
echo "  FROM image AS base        = shared base"
echo "  FROM base AS builder      = build/compile"
echo "  FROM builder AS tester    = run tests"
echo "  FROM base AS production   = final image"
echo "  FROM base AS dev          = development env"

echo ""
echo "[ BUILD SPECIFIC STAGE ]"
echo "  docker build --target builder -t myapp-builder ."
echo "  = only build up to 'builder' stage"
echo "  = useful for: running tests only"
echo "                development environments"
echo "                debugging build issues"

echo ""
echo "[ BUILDKIT FEATURES ]"
echo ""
echo "  Enable BuildKit:"
echo "  export DOCKER_BUILDKIT=1"
echo "  OR add to /etc/docker/daemon.json:"
echo "  {\"features\": {\"buildkit\": true}}"
echo ""
echo "  Cache mount (pip/npm cache):"
echo "  RUN --mount=type=cache,target=/root/.cache/pip \\"
echo "      pip install -r requirements.txt"
echo ""
echo "  Secret mount (API keys at build time):"
echo "  RUN --mount=type=secret,id=mykey \\"
echo "      cat /run/secrets/mykey"
echo "  Build: docker build --secret id=mykey,src=keyfile ."
echo ""
echo "  SSH agent forwarding (private repos):"
echo "  RUN --mount=type=ssh \\"
echo "      git clone git@github.com:private/repo.git"
echo "  Build: docker build --ssh default ."
echo ""
echo "  Heredoc syntax (cleaner scripts):"
echo "  RUN <<EOF"
echo "  apt-get update"
echo "  apt-get install -y curl wget"
echo "  EOF"

echo ""
echo "[ COMMON PATTERNS ]"
echo ""
echo "  Pattern 1: Compiler + Runtime"
echo "  FROM golang:1.21 AS builder"
echo "  RUN go build -o myapp"
echo "  FROM scratch AS production"
echo "  COPY --from=builder /app/myapp /"
echo "  CMD [\"/myapp\"]"
echo ""
echo "  Pattern 2: Dependencies + App"
echo "  FROM python:3.11-slim AS deps"
echo "  RUN pip install --prefix=/install -r requirements.txt"
echo "  FROM python:3.11-slim AS production"
echo "  COPY --from=deps /install /usr/local"
echo "  COPY app.py ."
echo ""
echo "  Pattern 3: With Testing"
echo "  FROM builder AS test"
echo "  RUN pytest tests/"
echo "  FROM builder AS production"
echo "  (test stage must pass or production skipped)"

echo ""
echo "[ SIZE REDUCTION CHECKLIST ]"
echo "  ✅ Use :slim or :alpine base images"
echo "  ✅ Multi-stage (no build tools in prod)"
echo "  ✅ COPY --from (only needed files)"
echo "  ✅ apt-get clean in same RUN layer"
echo "  ✅ pip install --no-cache-dir"
echo "  ✅ npm install --production"
echo "  ✅ .dockerignore (exclude unnecessary files)"
echo "  ✅ PYTHONDONTWRITEBYTECODE=1"
echo "  ✅ Remove test files from production"
echo "  ✅ Use BuildKit cache mounts"

echo ""
echo "[ CURRENT IMAGES ]"
docker images | grep -v "<none>" | \
    awk 'NR==1 || /python-|node-|buildkit|parallel|secure/' | \
    head -15

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
