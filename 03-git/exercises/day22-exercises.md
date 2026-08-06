# Day 22 Exercises — Advanced Git
**Date:** Jul 11 2026
**Status:** ✅ Completed

---

## Exercise 1: git rebase ✅
- [x] Created diverged branches
- [x] Used git rebase main
- [x] Achieved linear history
- [x] Used interactive rebase to squash commits

### Proof
See: practices/day22-practice/exercise1-proof.txt

### Commands Used
git rebase main              (standard rebase)
git rebase -i HEAD~3         (interactive)

### Interactive Rebase Commands
pick   = keep as is
squash = combine with previous
fixup  = squash and discard message
reword = keep but edit message
drop   = delete commit entirely

### Golden Rule
NEVER rebase shared/pushed branches
Only rebase local work before PR

---

## Exercise 2: git cherry-pick ✅
- [x] Created branch with multiple commits
- [x] Identified specific commit to copy
- [x] Cherry-picked only that commit to main
- [x] Verified other commits not in main

### Proof
See: practices/day22-practice/exercise2-proof.txt

### Commands Used
git cherry-pick abc1234      (single commit)
git cherry-pick abc..def     (range)
git cherry-pick abc def ghi  (multiple)

### Real Use Cases
- Emergency security fix from feature branch
- Copy hotfix to multiple release branches
- Port specific bug fix between versions

---

## Exercise 3: git reset ✅
- [x] Used --soft reset (keep staged)
- [x] Used --mixed reset (keep in working dir)
- [x] Used --hard reset (delete changes)
- [x] Understood when to use each

### Proof
See: practices/day22-practice/exercise3-proof.txt

### Three Modes
--soft  = undo commit, changes stay STAGED
--mixed = undo commit, changes in WORKING DIR
--hard  = undo commit, changes DELETED

### Memory Trick
--soft  = go back, suitcase still packed
--mixed = go back, unpack the suitcase
--hard  = go back, burn the suitcase

### Critical Rule
NEVER --hard on pushed commits
Use git revert for shared branches

---

## Exercise 4: git revert ✅
- [x] Created a bad commit
- [x] Reverted it safely
- [x] Verified history preserved
- [x] Understood revert vs reset

### Proof
See: practices/day22-practice/exercise4-proof.txt

### revert vs reset
revert: adds NEW undo commit (safe for shared)
reset:  rewrites history (local only)

Use revert on: main develop any pushed branch
Use reset on: local unpushed branches only

---

## Exercise 5: git reflog ✅
- [x] Viewed reflog history
- [x] Simulated accidental hard reset
- [x] Recovered using reflog hash
- [x] Simulated deleted branch recovery

### Proof
See: practices/day22-practice/exercise5-proof.txt

### Reflog Commands
git reflog               (view history)
git reset --hard @{2}    (go back to position)
git checkout -b name HASH (recover branch)

### Key Facts
- Reflog keeps history for 90 days
- Saves EVERY HEAD position
- Can recover from almost anything
- Only fails after 90 days or gc run

---

## Exercise 6: git bisect ✅
- [x] Understood binary search concept
- [x] Learned bisect commands
- [x] Learned automated bisect with run

### Proof
See: practices/day22-practice/exercise6-proof.txt

### bisect Process
git bisect start
git bisect bad           (current is broken)
git bisect good v1.0.0   (this worked)
(test each checkout)
git bisect good/bad
(repeat until found)
git bisect reset

200 commits = only ~8 tests needed

---

## Exercise 7: git clean ✅
- [x] Used -n dry run to preview
- [x] Used -f to remove untracked files
- [x] Learned -fd for directories
- [x] Learned -fdx for ignored files

### Proof
See: practices/day22-practice/exercise7-proof.txt

### Important
ALWAYS run git clean -n first (dry run)
Cannot recover cleaned files without stash

---

## Summary
All 7 exercises completed on Jul 11 2026

Scripts written:
- advanced-git-reference.sh

Practice project:
- advanced-git-practice/

Proof files:
- exercise1-proof.txt (rebase)
- exercise2-proof.txt (cherry-pick)
- exercise3-proof.txt (reset)
- exercise4-proof.txt (revert)
- exercise5-proof.txt (reflog)
- exercise6-proof.txt (bisect)
- exercise7-proof.txt (clean)
- script-output-advanced.txt

Emergency commands learned:
- Wrong branch: cherry-pick + reset
- Deleted branch: reflog + checkout -b
- Bad code on main: revert + push
- Hard reset accident: reflog + reset
- Sensitive data committed: reset/BFG
