# Day 8 Exercises — Vim Editor
**Date:** Jun 28 2026
**Status:** ✅ Completed

---

## Exercise 1: Open Exit Vim ✅
- [x] Opened vim with vim test-file.txt
- [x] Entered insert mode with i
- [x] Typed text
- [x] Exited insert mode with Escape
- [x] Saved with :w
- [x] Quit with :q

### Proof
See: practices/day08-practice/exercise1-proof.txt

### What I Learned
- Vim opens in NORMAL mode by default
- Must press i to type text
- Must press Escape to stop typing
- :w saves without quitting
- :q quits after saving
- :q! quits without saving (force)
- :wq saves and quits together

---

## Exercise 2: Navigation ✅
- [x] Navigated with h j k l
- [x] Used gg and G for file start end
- [x] Used / for searching
- [x] Used 0 and $ for line start end
- [x] Used :number to go to specific line

### Proof
See: practices/day08-practice/exercise2-proof.txt

### Key Navigation Commands
h = left    j = down    k = up    l = right
w = word forward        b = word backward
gg = file start         G = file end
0 = line start          $ = line end
/word = search          n = next match

---

## Exercise 3: Search and Replace ✅
- [x] Used :%s/old/new/g to replace all
- [x] Replaced development with production
- [x] Replaced old hostnames with new ones
- [x] Changed DEBUG to INFO

### Proof
See: practices/day08-practice/exercise3-proof.txt

### Key Command
:%s/old/new/g
: = command mode
% = entire file
s = substitute
/old/ = find this
/new/ = replace with
/g = global (all occurrences)

---

## Exercise 4: Real Config Editing ✅
- [x] Edited nginx config file
- [x] Replaced server names and IPs
- [x] Added comment at end of file
- [x] Used :set number to show lines

### Proof
See: practices/day08-practice/exercise4-proof.txt

### Real DevOps Value
This is exactly what happens in production:
SSH into server → vim config → search replace
→ save → restart service → done

---

## Vim Modes Reference ✅
- [x] NORMAL = navigation and commands
- [x] INSERT = typing text (i to enter)
- [x] VISUAL = selecting text (v to enter)
- [x] COMMAND = running commands (: to enter)
- [x] Escape = always returns to NORMAL

---

## .vimrc Configuration ✅
- [x] Created ~/.vimrc
- [x] Enabled line numbers
- [x] Enabled syntax highlighting
- [x] Set tab width to 2 spaces
- [x] Enabled auto indent

---

## Summary
All 4 exercises completed on Jun 28 2026

Scripts written:
- vim-basics.sh (complete Vim reference)
- vim-devops.sh (real DevOps scenarios)

Practice files:
- test-file.txt
- nginx-config.txt (edited with Vim)
- app-config.txt (edited with Vim)

Proof files:
- exercise1-proof.txt
- exercise2-proof.txt
- exercise3-proof.txt
- exercise4-proof.txt
- script-output-basics.txt
- script-output-devops.txt

Key concepts learned:
- Vim modes (Normal Insert Visual Command)
- Navigation without mouse
- Search and replace in Vim
- Real DevOps config file editing
- .vimrc personal configuration
- Vim vs nano vs VSCode comparison
