# Day 7 Exercises — Text Processing
**Date:** Jun 27 2026
**Status:** ✅ Completed

---

## Exercise 1: grep ✅
- [x] Basic search for ERROR
- [x] Case insensitive with -i
- [x] Count matches with -c
- [x] Show line numbers with -n
- [x] Invert match with -v
- [x] Context before with -B 2
- [x] Context after with -A 2
- [x] Multiple patterns with -E

### Proof
See: practices/day07-practice/exercise1-proof.txt
See: practices/day07-practice/grep-practice.sh

### Key Commands
grep "ERROR" app.log
grep -c "ERROR" app.log
grep -n "ERROR" app.log
grep -v "INFO" app.log
grep -B 2 "CRITICAL" app.log
grep -E "ERROR|CRITICAL" app.log

### What I Learned
- grep = search for patterns in files
- -i = case insensitive
- -c = count only
- -n = show line numbers
- -v = invert (show non-matching)
- -B = lines before match
- -A = lines after match
- -E = extended regex with | OR

---

## Exercise 2: sed ✅
- [x] Find and replace text
- [x] Delete matching lines
- [x] Print specific line range
- [x] Redact sensitive data

### Proof
See: practices/day07-practice/exercise2-proof.txt
See: practices/day07-practice/sed-practice.sh

### Key Commands
sed 's/ERROR/ALERT/g' app.log
sed '/INFO/d' app.log
sed -n '5,10p' app.log
sed 's/192\.168\.[0-9]*/REDACTED/g' app.log

### What I Learned
- sed = stream editor
- s/old/new/g = substitute globally
- /pattern/d = delete matching lines
- -n + /pattern/p = print matching only
- -n '5,10p' = print line range
- Original file safe without -i flag

---

## Exercise 3: awk ✅
- [x] Print specific columns with $1 $2 $3
- [x] Count log levels
- [x] Filter by condition
- [x] Count with END block
- [x] Add line numbers with NR

### Proof
See: practices/day07-practice/exercise3-proof.txt
See: practices/day07-practice/awk-practice.sh

### Key Commands
awk '{print $1}' app.log
awk '{print $3}' app.log | sort | uniq -c
awk '$3 == "ERROR" {print}' app.log
awk '$3=="ERROR"{count++} END{print count}' app.log

### What I Learned
- awk splits lines into $1 $2 $3 fields
- $0 = entire line
- $NF = last field
- NR = current line number
- Conditions filter which lines process
- END block runs after all lines done
- count++ increments counter

---

## Exercise 4: cut ✅
- [x] Extract date column
- [x] Extract multiple columns
- [x] Extract from position to end
- [x] Use colon as delimiter

### Proof
See: practices/day07-practice/exercise4-proof.txt

### Key Commands
cut -d' ' -f1 app.log
cut -d' ' -f1,2 app.log
cut -d' ' -f4- app.log
echo "a:b:c" | cut -d':' -f2

### What I Learned
- cut = simple fast column extraction
- -d = delimiter character
- -f = field number to extract
- -f4- = field 4 to end of line
- Faster than awk for simple extraction
- No conditions or math capability

---

## Exercise 5: sort uniq wc tr ✅
- [x] Sort log file alphabetically
- [x] Count log levels with uniq -c
- [x] Count lines with wc -l
- [x] Convert case with tr

### Proof
See: practices/day07-practice/exercise5-proof.txt

### Key Commands
sort app.log
awk '{print $3}' app.log | sort | uniq -c | sort -rn
wc -l app.log
echo "hello" | tr 'a-z' 'A-Z'

### What I Learned
- sort = organize lines alphabetically
- Always sort BEFORE uniq
- uniq only removes consecutive duplicates
- uniq -c = count each unique item
- sort -rn = numeric reverse sort
- wc -l = count lines
- tr = translate/convert characters

---

## Exercise 6: Combined Pipeline ✅
- [x] Most problematic component
- [x] Suspicious IP detection
- [x] Full incident report pipeline

### Key Pipeline
grep -E "ERROR|CRITICAL" app.log \
| awk '{print $4}' \
| sort | uniq -c | sort -rn

### What This Does
1. grep finds all error/critical lines
2. awk extracts component column
3. sort groups same components
4. uniq -c counts each component
5. sort -rn shows most broken first

---

## Exercise 7: log-analyzer.sh Script ✅
- [x] Script accepts log file as argument
- [x] Checks file exists before running
- [x] Shows log level breakdown
- [x] Shows all errors
- [x] Detects critical events with context
- [x] Identifies most affected components
- [x] Detects suspicious IP addresses
- [x] Output saved as script-output.txt

### Proof
See: practices/day07-practice/log-analyzer.sh
See: practices/day07-practice/script-output.txt

---

## Summary
All 7 exercises completed on Jun 27 2026

Scripts written:
- grep-practice.sh
- sed-practice.sh
- awk-practice.sh
- log-analyzer.sh (main professional tool)

Proof files:
- exercise1-proof.txt
- exercise2-proof.txt
- exercise3-proof.txt
- exercise4-proof.txt
- exercise5-proof.txt
- script-output-grep.txt
- script-output-sed.txt
- script-output-awk.txt
- script-output.txt

Key concepts learned:
- grep = search patterns
- sed = find and replace
- awk = column extraction and analysis
- cut = simple column extraction
- sort = organize output
- uniq -c = count occurrences
- wc -l = count lines
- tr = translate characters
- pipe | = chain tools together
