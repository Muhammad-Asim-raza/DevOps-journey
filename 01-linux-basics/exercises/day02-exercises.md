# Day 2 Exercises — Linux Commands
**Date:** Jun 22 2026
**Status:** ✅ Completed

---

## Exercise 1: Reading Files ✅

### Tasks
- [x] Read server.log using cat
- [x] See first 5 lines using head
- [x] See last 5 lines using tail

### Commands I Used
cat server.log
head -5 server.log
tail -5 server.log

### What I Learned
- cat shows entire file at once
- head shows oldest events at top
- tail shows newest events at bottom
- tail -f watches file live in real time

---

## Exercise 2: Searching with grep ✅

### Tasks
- [x] Find all ERROR lines
- [x] Find all WARNING lines
- [x] Count how many errors exist

### Commands I Used
grep "ERROR" server.log
grep "WARNING" server.log
grep "ERROR" server.log | wc -l

### My Output
- ERROR lines found  = 6
- WARNING lines found = 3

### What I Learned
- grep searches inside files instantly
- grep -i ignores capital letters
- | pipe sends output to next command
- wc -l counts lines

---

## Exercise 3: Pipe and Save ✅

### Tasks
- [x] Save all errors to errors-only.txt
- [x] Add warnings to same file using >>
- [x] Count total lines in errors-only.txt

### Commands I Used
grep "ERROR" server.log > errors-only.txt
grep "WARNING" server.log >> errors-only.txt
cat errors-only.txt | wc -l

### My Output
- errors-only.txt total lines = 9
- 6 errors + 3 warnings = 9 total

### What I Learned
- > creates new file and saves into it
- >> adds to existing file without deleting
- Always use >> when adding to existing file
- Use > only when starting fresh

---

## Exercise 4: Find and Sort ✅

### Tasks
- [x] Find server.log using find command
- [x] Sort server.log and save to sorted.log
- [x] Count each log type (INFO/ERROR/WARNING)

### Commands I Used
find ~ -name "server.log"
sort server.log > sorted.log
grep -o "INFO\|ERROR\|WARNING" server.log | sort | uniq -c

### My Output
- server.log location = /home/asim_raza/DevOps-journey/
                        01-linux-basics/day02-practice/server.log
- Log summary:
  6 ERROR
  11 INFO
  3 WARNING

### What I Learned
- find searches entire system for files
- sort organizes lines alphabetically
- uniq -c counts repeated items
- Combining pipe + grep + sort + uniq
  gives powerful log analysis

---

## Summary
All 4 exercises completed on Jun 22 2026.
Files created: server.log, errors-only.txt, sorted.log
Key concepts learned:
- Reading files (cat, head, tail)
- Searching files (grep)
- Chaining commands (pipe |)
- Saving output (> and >>)
- Finding files (find)
- Sorting and counting (sort, uniq -c)
