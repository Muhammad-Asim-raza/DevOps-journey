#!/bin/bash
# ================================================
# github-workflow.sh
# Complete GitHub Workflow Reference
# Author: Asim Raza
# Day 21 of DevOps Journey
# ================================================

echo "============================================"
echo "   GITHUB WORKFLOW REFERENCE"
echo "   Author: Asim Raza - Day 21"
echo "============================================"

echo ""
echo "[ REMOTE COMMANDS ]"
echo "  git remote -v                    = list remotes"
echo "  git remote add name URL          = add remote"
echo "  git remote remove name           = remove remote"
echo "  git remote rename old new        = rename"
echo "  git remote set-url name URL      = change URL"

echo ""
echo "[ FETCH vs PULL vs PUSH ]"
echo "  git fetch origin                 = download only"
echo "  git pull origin main             = download + merge"
echo "  git pull --rebase origin main    = download + rebase"
echo "  git push origin main             = upload commits"
echo "  git push -u origin branch        = push + set tracking"
echo "  git push origin --delete branch  = delete remote branch"
echo "  git push origin --tags           = push all tags"

echo ""
echo "[ PULL REQUEST WORKFLOW ]"
echo "  1. git switch -c feature/name"
echo "  2. (make changes and commits)"
echo "  3. git push -u origin feature/name"
echo "  4. Open PR on GitHub"
echo "  5. Add description and reviewers"
echo "  6. CI checks run automatically"
echo "  7. Address review feedback"
echo "  8. Get approval"
echo "  9. Merge PR"
echo " 10. git branch -d feature/name"

echo ""
echo "[ GIT STASH ]"
echo "  git stash                        = save changes"
echo "  git stash list                   = show all stashes"
echo "  git stash pop                    = restore + remove"
echo "  git stash apply stash@{0}        = restore + keep"
echo "  git stash save 'description'     = named stash"
echo "  git stash drop stash@{0}         = delete stash"
echo "  git stash clear                  = delete all stashes"

echo ""
echo "[ GIT TAGS ]"
echo "  git tag                          = list tags"
echo "  git tag v1.0.0                   = lightweight tag"
echo "  git tag -a v1.0.0 -m 'msg'       = annotated tag"
echo "  git push origin v1.0.0           = push one tag"
echo "  git push origin --tags           = push all tags"
echo "  git tag -d v1.0.0                = delete local tag"
echo "  git show v1.0.0                  = tag details"

echo ""
echo "[ FORKING WORKFLOW ]"
echo "  Fork on GitHub → clone fork locally"
echo "  git remote add upstream ORIGINAL_URL"
echo "  git fetch upstream"
echo "  git merge upstream/main"
echo "  (contribute via PR from fork)"

echo ""
echo "[ BRANCH PROTECTION (configure on GitHub) ]"
echo "  Settings → Branches → Add rule for main:"
echo "  ✅ Require PR before merging"
echo "  ✅ Require approvals (minimum 1)"
echo "  ✅ Require status checks (CI tests)"
echo "  ✅ No direct pushes to main"

echo ""
echo "[ CURRENT REPO STATUS ]"
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "  Remotes:"
    git remote -v 2>/dev/null | sed 's/^/    /'
    echo "  Tags:"
    git tag 2>/dev/null | sed 's/^/    /'
    echo "  Branches:"
    git branch -a 2>/dev/null | sed 's/^/    /'
fi

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
