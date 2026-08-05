# Day 21 Exercises — Remote Repos GitHub Workflow PRs
**Date:** Jul 10 2026
**Status:** ✅ Completed

---

## Exercise 1: git remote Commands ✅
- [x] Viewed remotes with git remote -v
- [x] Learned add remove rename commands
- [x] Understood multiple remotes

### Proof
See: practices/day21-practice/exercise1-proof.txt

### Key Commands
git remote -v                    (view)
git remote add upstream URL      (add)
git remote remove upstream       (remove)
git remote rename origin github  (rename)
git remote set-url origin URL    (change URL)

### What I Learned
- Remote = connection to server repo
- origin = standard name for your GitHub repo
- upstream = standard name for original (when forking)
- Can have multiple remotes simultaneously

---

## Exercise 2: Fetch Pull Push ✅
- [x] Understood difference between all three
- [x] Learned git pull --rebase
- [x] Learned push with tracking (-u flag)
- [x] Learned deleting remote branches

### Proof
See: practices/day21-practice/exercise2-proof.txt

### Key Difference
fetch = download only (safe, no changes to files)
pull  = fetch + merge (applies changes immediately)
push  = upload local commits to remote

### What I Learned
- Always pull before pushing in teams
- --rebase keeps linear history
- -u sets upstream tracking
- push --delete removes remote branches

---

## Exercise 3: Pull Request Workflow ✅
- [x] Created PR-ready feature branch
- [x] Wrote good commit messages
- [x] Added tests with the feature
- [x] Created PR description template
- [x] Checked what PR would contain

### Proof
See: practices/day21-practice/exercise3-proof.txt

### PR Checklist
- [ ] Descriptive branch name (feature/xxx)
- [ ] Small focused commits
- [ ] Tests included
- [ ] All tests pass
- [ ] PR description filled in
- [ ] Reviewer assigned
- [ ] No secrets in code

### PR Description Template
## What This PR Does
(describe the change)

## How to Test
(steps to verify)

## Checklist
- [ ] Tests added
- [ ] All tests pass
- [ ] No secrets committed

---

## Exercise 4: Branch Protection ✅
- [x] Learned why protection matters
- [x] Studied GitHub settings for main
- [x] Understood required checks

### Proof
See: practices/day21-practice/exercise4-proof.txt

### Protection Rules for main
✅ Require PR before merging
✅ Require 1 approval minimum
✅ Require CI status checks
✅ No direct pushes allowed
✅ No bypassing (even admins)

---

## Exercise 5: git stash ✅
- [x] Saved work with git stash
- [x] Verified clean working directory
- [x] Restored work with git stash pop
- [x] Learned stash list apply drop

### Proof
See: practices/day21-practice/exercise5-proof.txt

### When to Use stash
- Urgent bug fix interrupts your work
- Need to switch branches without committing
- Want to try something risky
- Pull but have local changes blocking it

### Key Commands
git stash              (save all changes)
git stash pop          (restore + remove)
git stash list         (see all stashes)
git stash apply @{0}   (restore + keep)
git stash save "desc"  (named stash)

---

## Exercise 6: git tag ✅
- [x] Created lightweight tags
- [x] Created annotated tags with messages
- [x] Listed all tags
- [x] Viewed tag details with git show

### Proof
See: practices/day21-practice/exercise6-proof.txt

### Semantic Versioning
v1.0.0 = MAJOR.MINOR.PATCH
MAJOR = breaking changes
MINOR = new features (backward compatible)
PATCH = bug fixes only

### Key Commands
git tag -a v1.0.0 -m "Initial release"
git tag (list)
git push origin --tags (push to GitHub)
git show v1.0.0 (see details)

---

## Exercise 7: Forking Workflow ✅
- [x] Understood fork vs clone difference
- [x] Learned fork workflow steps
- [x] Learned upstream remote pattern
- [x] Understood how to keep fork updated

### Proof
See: practices/day21-practice/exercise7-proof.txt

### Fork vs Clone
Clone = local copy, same repository
Fork  = YOUR OWN copy on GitHub

### Fork Workflow
Fork → Clone fork → Add upstream remote
→ Branch → Commit → Push to fork
→ PR from fork to original

---

## Summary
All 7 exercises completed on Jul 10 2026

Scripts written:
- github-workflow.sh (complete reference)

Practice project:
- pr-practice/ (feature branch + tests + tags)

Proof files:
- exercise1-proof.txt (git remote)
- exercise2-proof.txt (fetch pull push)
- exercise3-proof.txt (PR workflow)
- exercise4-proof.txt (branch protection)
- exercise5-proof.txt (git stash)
- exercise6-proof.txt (git tag)
- exercise7-proof.txt (forking)
- script-output-github-workflow.txt

Key concepts learned:
- Remote repositories and commands
- Fetch vs pull vs push difference
- Pull Request complete workflow
- Branch protection rules
- git stash for temporary saves
- git tag for release management
- Forking workflow for open source
