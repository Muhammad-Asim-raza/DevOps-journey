# Day 20 Exercises — Git Branching and Merging
**Date:** Jul 09 2026
**Status:** ✅ Completed

---

### Exercise 1: git branch Commands ✅
- [x] Listed branches with git branch
- [x] Created branch with git branch name
- [x] Listed all including remote with -a
- [x] Deleted branch with -d flag

### Proof
See: practices/day20-practice/exercise1-proof.txt

### Commands Used
git branch              (list)
git branch feature/test (create)
git branch -a           (list all + remote)
git branch -d branch    (safe delete)
git branch -D branch    (force delete)

### What I Learned
- Branch = lightweight pointer to a commit
- Creating branch does NOT copy files
- * shows current branch
- -d only deletes merged branches (safe)
- -D force deletes even unmerged branches

---

## Exercise 2: Switching Branches ✅
- [x] Used git switch to change branches
- [x] Used git switch -c to create and switch
- [x] Verified files change between branches
- [x] Confirmed feature branch is isolated

### Proof
See: practices/day20-practice/exercise2-proof.txt

### Commands Used
git switch main              (switch)
git switch -c feature/login  (create + switch)
git checkout branch-name     (old way)
git checkout -b new-branch   (old create + switch)

### Key Insight
When on feature/login branch:
auth.py exists and app.py has login function

When on main branch:
auth.py does NOT exist
app.py does NOT have login function

Branches are completely isolated!

---

## Exercise 3: Fast-Forward Merge ✅
- [x] Created feature branch from main
- [x] Made commits on feature branch
- [x] Switched to main
- [x] Merged feature into main
- [x] Saw fast-forward in action

### Proof
See: practices/day20-practice/exercise3-proof.txt

### Fast-Forward Happens When
main has NOT moved since branching
Git just moves main pointer forward
No merge commit created
Clean linear history

### Commands Used
git switch main
git merge feature/login
git branch -d feature/login

---

## Exercise 4: Three-Way Merge ✅
- [x] Created feature branch
- [x] Made commits on feature branch
- [x] Made DIFFERENT commits on main
- [x] Merged (three-way merge created)
- [x] Saw merge commit in graph

### Proof
See: practices/day20-practice/exercise4-proof.txt

### Three-Way Merge Happens When
Both branches have new commits
since they diverged
Git needs to combine TWO different histories
Creates a MERGE COMMIT with two parents

### Graph Shows
*   merge commit (two parents)
|\
| * feature commits
* | main commits
|/
* common ancestor

---

## Exercise 5: Merge Conflicts ✅
- [x] Created conflict intentionally
- [x] Read conflict markers
- [x] Resolved conflict manually
- [x] Committed resolved file

### Proof
See: practices/day20-practice/exercise5-proof.txt

### Conflict Markers
<<<<<<< HEAD
YOUR version (current branch)
=======
THEIR version (branch being merged)
>>>>>>> feature/version-update

### Resolution Steps
1. Open conflicted file in editor
2. Remove ALL conflict markers
3. Keep the correct version
4. git add resolved-file
5. git commit

### Prevention Tips
- Merge often (smaller conflicts)
- Communicate with team about shared files
- Use pull requests for review first

---

## Exercise 6: Branching Strategies ✅
- [x] Learned GitFlow (enterprise)
- [x] Learned GitHub Flow (modern)
- [x] Learned Trunk Based Development
- [x] Applied GitHub Flow in demo

### Proof
See: practices/day20-practice/script-output-github-flow.txt

### GitHub Flow Summary
main = always deployable
feature/xxx = any change
Pull Request = discussion + review
Tests pass → Merge to main → Deploy

### When to Use Which
GitHub Flow: most companies, startups
GitFlow: enterprises, slow releases
Trunk Based: Google, Netflix, big tech

---

## Scripts Written
- branching-practice.sh (complete reference)
- github-flow-demo.sh (strategy demo)

### Proof
See: practices/day20-practice/script-output-branching.txt
See: practices/day20-practice/script-output-github-flow.txt

---

## Summary
All 6 exercises completed on Jul 09 2026

Scripts written:
- branching-practice.sh
- github-flow-demo.sh

Practice project:
- branch-practice/ (multiple branches merged)

Key concepts learned:
- Branch = lightweight pointer (not file copy)
- Fast-forward vs three-way merge
- Merge conflict resolution
- GitFlow vs GitHub Flow vs Trunk Based
- Branch naming conventions
- When to use each strategy
