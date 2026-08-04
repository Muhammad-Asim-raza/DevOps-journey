#!/bin/bash
# ================================================
# branching-practice.sh
# Git Branching Reference and Demo
# Author: Asim Raza
# Day 20 of DevOps Journey
# ================================================

echo "============================================"
echo "   GIT BRANCHING REFERENCE"
echo "   Author: Asim Raza - Day 20"
echo "============================================"

echo ""
echo "[ BRANCH COMMANDS ]"
echo "  git branch                  = list branches"
echo "  git branch name             = create branch"
echo "  git branch -d name          = delete (safe)"
echo "  git branch -D name          = delete (force)"
echo "  git branch -a               = list all + remote"
echo "  git branch -m old new       = rename"

echo ""
echo "[ SWITCHING BRANCHES ]"
echo "  git switch branch-name      = switch (modern)"
echo "  git switch -c new-branch    = create and switch"
echo "  git checkout branch-name    = switch (old way)"
echo "  git checkout -b new-branch  = create and switch"

echo ""
echo "[ MERGING ]"
echo "  git merge branch-name       = merge into current"
echo "  git merge --no-ff branch    = always create merge commit"
echo "  git merge --abort           = cancel merge"
echo "  git merge --squash branch   = squash all commits"

echo ""
echo "[ CONFLICT RESOLUTION ]"
echo "  1. git merge branch-name    (triggers conflict)"
echo "  2. Edit conflicted files"
echo "  3. Remove conflict markers: <<<<< ===== >>>>>"
echo "  4. git add resolved-file"
echo "  5. git commit"

echo ""
echo "[ BRANCH NAMING CONVENTIONS ]"
echo "  feature/feature-name        = new features"
echo "  fix/bug-description         = bug fixes"
echo "  hotfix/critical-fix         = emergency fixes"
echo "  release/version-number      = release prep"
echo "  chore/task-description      = maintenance"
echo "  docs/doc-name               = documentation"

echo ""
echo "[ CURRENT REPOSITORY STATE ]"
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "  Branches:"
    git branch -a | sed 's/^/    /'
    echo ""
    echo "  Recent history:"
    git log --oneline --graph --all -10 | sed 's/^/    /'
else
    echo "  Not in a git repository"
fi

echo ""
echo "[ BRANCHING STRATEGIES ]"
echo "  GitHub Flow (recommended):"
echo "    main = production (always deployable)"
echo "    feature/xxx = any change"
echo "    Rules: PR → review → tests → merge → deploy"
echo ""
echo "  GitFlow (enterprise):"
echo "    main = production"
echo "    develop = integration"
echo "    feature/xxx = features"
echo "    release/xxx = release prep"
echo "    hotfix/xxx = emergency fixes"

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
