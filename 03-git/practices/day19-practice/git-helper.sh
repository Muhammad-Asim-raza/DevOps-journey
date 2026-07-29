#!/bin/bash
# ================================================
# git-helper.sh
# Git Commands Reference and Demo
# Author: Asim Raza
# Day 19 of DevOps Journey
# ================================================

echo "============================================"
echo "   GIT HELPER REFERENCE"
echo "   Author: Asim Raza - Day 19"
echo "============================================"

# Check if in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Not in a git repository!"
    echo "Run: git init"
    exit 1
fi

echo ""
echo "[ REPOSITORY INFO ]"
echo "  Location: $(git rev-parse --show-toplevel)"
echo "  Branch  : $(git branch --show-current)"
echo "  Remote  : $(git remote get-url origin 2>/dev/null \
    || echo 'No remote configured')"

echo ""
echo "[ CURRENT STATUS ]"
git status --short
# --short = compact status output
# M  = modified
# A  = added (staged)
# ?? = untracked
# !! = ignored

echo ""
echo "[ RECENT COMMITS (last 10) ]"
git log --oneline -10

echo ""
echo "[ COMMIT STATISTICS ]"
echo "  Total commits: $(git rev-list --count HEAD 2>/dev/null)"
echo "  Contributors: $(git log --format='%an' | sort -u | wc -l)"
echo "  Files tracked: $(git ls-files | wc -l)"

echo ""
echo "[ MOST CHANGED FILES ]"
git log --name-only --pretty=format: | \
    sort | uniq -c | sort -rn | \
    head -5 | awk '{printf "  %s changes: %s\n", $1, $2}'

echo ""
echo "[ COMMON GIT COMMANDS ]"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  git init                = start repo"
echo "  git add .               = stage all"
echo "  git commit -m 'msg'     = save snapshot"
echo "  git push origin main    = upload"
echo "  git pull origin main    = download"
echo "  git log --oneline       = view history"
echo "  git diff                = see changes"
echo "  git status              = check state"
echo "  git branch              = list branches"
echo "  git checkout -b name    = new branch"
echo "  git merge branch-name   = merge branch"
echo "  git clone url           = copy remote repo"
echo "  git stash               = save work temp"
echo "  git stash pop           = restore stashed"

echo ""
echo "============================================"
echo "   GIT REFERENCE COMPLETE"
echo "============================================"
