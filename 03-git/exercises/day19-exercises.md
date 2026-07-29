# Day 19 Exercises — Git Fundamentals
**Date:** Jul 08 2026
**Status:** ✅ Completed

---

## Exercise 1: git init ✅
- [x] Created new project directory
- [x] Ran git init
- [x] Explored .git directory structure
- [x] Understood what each folder does

### Proof
See: practices/day19-practice/exercise1-proof.txt

### What git init creates
.git/HEAD      = points to current branch
.git/config    = repository settings
.git/objects/  = all file contents stored here
.git/refs/     = branch and tag pointers

### What I Learned
- git init creates .git hidden folder
- .git folder IS the entire repository
- Deleting .git = losing all history
- Every project needs ONE git init

---

## Exercise 2: git add (Staging) ✅
- [x] Created multiple files
- [x] Used git add for single file
- [x] Used git add . for all files
- [x] Used git restore --staged to unstage
- [x] Excluded .env file intentionally

### Proof
See: practices/day19-practice/exercise2-proof.txt

### Commands Used
git add README.md          (single file)
git add app.py src/ tests/ (multiple)
git add .                  (all files)
git restore --staged .env  (unstage)

### Three Areas of Git
Working Directory → [git add] → Staging Area → [git commit] → Repository

### What I Learned
- git add moves files to staging area
- Staging lets you choose what to commit
- You can add files selectively
- .env should NEVER be staged/committed

---

## Exercise 3: git commit ✅
- [x] Made first commit with -m message
- [x] Made multiple commits
- [x] Viewed history with git log
- [x] Learned good commit message format

### Proof
See: practices/day19-practice/exercise3-proof.txt

### Commands Used
git commit -m "message"
git log
git log --oneline

### Good Commit Message Rules
- Present tense: "Add feature" not "Added"
- Under 72 characters for title
- Explain WHAT and WHY
- Not HOW (code shows how)

### What I Learned
- Commit = permanent snapshot
- Every commit has unique hash
- HEAD points to latest commit
- git log shows full history

---

## Exercise 4: git log Deep Dive ✅
- [x] Used git log --oneline
- [x] Used git log --graph --decorate
- [x] Used git log --stat
- [x] Used git blame
- [x] Used git show on specific commit

### Proof
See: practices/day19-practice/exercise4-proof.txt

### Commands Used
git log --oneline --graph --decorate --all
git log --stat
git log --author="Asim"
git blame app.py
git show <commit-hash>

### What I Learned
- --oneline = compact one line per commit
- --graph = shows branch structure visually
- --stat = shows files changed per commit
- git blame = who changed each line
- git show = full details of one commit

---

## Exercise 5: git diff ✅
- [x] Used git diff for unstaged changes
- [x] Used git diff --staged for staged
- [x] Compared two commits
- [x] Read + and - in diff output

### Proof
See: practices/day19-practice/exercise5-proof.txt

### Commands Used
git diff              (unstaged vs last commit)
git diff --staged     (staged vs last commit)
git diff hash1 hash2  (compare two commits)

### Reading diff output
+ lines = added (green)
- lines = removed (red)
@@ = line numbers where change occurred

### What I Learned
- git diff without args = unstaged changes
- git diff --staged = what will be committed
- Always review diff before committing
- Diff shows exact changes line by line

---

## Exercise 6: .gitignore ✅
- [x] Created comprehensive .gitignore
- [x] Verified .env is ignored
- [x] Tested with git check-ignore -v
- [x] Understood what to always ignore

### Proof
See: practices/day19-practice/exercise6-proof.txt

### Always Ignore These
.env files          (secrets/passwords)
*.key *.pem files   (SSH/SSL private keys)
node_modules/       (dependencies)
*.tfstate           (Terraform state)
*.log files         (log output)
.DS_Store           (Mac system files)

### Commands Used
git check-ignore -v .env
git status (verify .env not shown)

### What I Learned
- .gitignore prevents files from being tracked
- One rule per line
- * = wildcard match
- Use git check-ignore to verify rules
- Global gitignore: ~/.gitignore_global

---

## Exercise 7: git push and pull ✅
- [x] Added remote with git remote add
- [x] Pushed to GitHub with git push
- [x] Understood git pull = fetch + merge
- [x] Learned git fetch for preview

### Proof
See: practices/day19-practice/exercise7-proof.txt

### Commands Used
git remote add origin URL
git remote -v
git push origin main
git pull origin main
git fetch origin

### What I Learned
- remote = connection to GitHub server
- origin = standard name for main remote
- push = upload local commits to GitHub
- pull = download + merge remote changes
- fetch = download only (no merge)
- Always pull before push in teams

---

## Summary
All 7 exercises completed on Jul 08 2026

Scripts written:
- git-helper.sh (complete Git reference)

Practice project created:
- git-practice-project/ (7 commits)

Proof files:
- exercise1-proof.txt (git init)
- exercise2-proof.txt (git add)
- exercise3-proof.txt (git commit)
- exercise4-proof.txt (git log)
- exercise5-proof.txt (git diff)
- exercise6-proof.txt (.gitignore)
- exercise7-proof.txt (push/pull)
- script-output-git-helper.txt

Key concepts learned:
- Git vs GitHub difference
- Three areas: Working/Staging/Repository
- git init add commit log diff status
- Good commit message format
- .gitignore what to exclude
- push and pull workflow
- git blame and show
