# Day 4 Exercises — Bash Scripting
**Date:** Jun 24 2026
**Status:** ✅ Completed

---

## Exercise 1: Variables ✅
- [x] Created variables.sh
- [x] Used string and number variables
- [x] Stored command output in variable

### Commands I Used
NAME="Asim"
echo "$NAME"
DISK=$(df -h / | tail -1 | awk '{print $5}')

### What I Learned
- Variables store information for reuse
- $ accesses variable value
- $() stores command output in variable
- Special variables: $USER $HOME $PWD $HOSTNAME

---

## Exercise 2: User Input ✅
- [x] Created user-input.sh
- [x] Used read to get input
- [x] Used read -p for inline prompt

### What I Learned
- read waits for user to type something
- read -p shows prompt on same line
- Input stored in variable automatically

---

## Exercise 3: Conditions ✅
- [x] Created conditions.sh
- [x] Used if/else to check disk usage
- [x] Used if to check service status
- [x] Used if to check file exists

### Comparison Operators
-gt = greater than
-lt = less than
-eq = equal to
-ne = not equal to
-f  = file exists
-d  = directory exists

---

## Exercise 4: Loops ✅
- [x] Created loops.sh
- [x] Used for loop with list
- [x] Used for loop with range
- [x] Used while loop with counter

### What I Learned
- for loops iterate over a list
- {1..5} creates range 1 to 5
- while loops run while condition is true
- Loops automate repetitive tasks

---

## Exercise 5: Functions ✅
- [x] Created functions.sh
- [x] Defined reusable functions
- [x] Passed arguments to functions
- [x] Called functions multiple times

### What I Learned
- Functions are reusable code blocks
- $1 $2 $3 are function arguments
- Define once, use many times
- Makes scripts clean and organized

---

## Exercise 6: Complete Health Checker ✅
- [x] Combined all concepts
- [x] devops-health-checker.sh works
- [x] Output saved to script-output.txt

---

## Summary
All exercises completed on Jun 24 2026.
Scripts written:
- variables.sh
- user-input.sh
- conditions.sh
- loops.sh
- functions.sh
- devops-health-checker.sh

Key concepts learned:
- Variables (store and reuse data)
- User input (read command)
- Conditions (if/else decisions)
- Loops (for/while repetition)
- Functions (reusable code blocks)
