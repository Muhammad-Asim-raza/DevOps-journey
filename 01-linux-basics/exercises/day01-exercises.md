# Day 1 Exercises — Linux Basics
**Date:** Jun 21 2026  
**Status:** ✅ Completed

---

## Exercise 1: Navigation ✅

### Tasks
- [x] Navigate to /etc and list all files
- [x] Find the largest file in /var/log
- [x] Count how many files are in /bin

### My Output
- /etc contains all Linux config files
- Largest file in /var/log = syslog (396K)
- Total files in /bin = 842

### Commands I Used
cd /etc
ls
cd /var/log
ls -lh
ls /bin | wc -l

### What I Learned
/etc stores all configuration files.
/var/log stores all system logs.
/bin stores all Linux commands.

---

## Exercise 2: File Operations ✅

### Tasks
- [x] Create a folder called practice
- [x] Create 5 files named file1.txt to file5.txt
- [x] Copy file1.txt to file1.txt.bak
- [x] Move file2.txt into subfolder called moved
- [x] Delete file3.txt

### Commands I Used
mkdir practice
cd practice
touch file1.txt file2.txt file3.txt file4.txt file5.txt
cp file1.txt file1.txt.bak
mkdir moved
mv file2.txt moved/
rm file3.txt

### What I Learned
touch creates empty files.
cp copies without deleting original.
mv moves OR renames a file.
rm deletes permanently. No recycle bin in Linux!

---

## Exercise 3: Permissions ✅

### Tasks
- [x] Create hello.sh that prints Hello DevOps
- [x] Try running without execute permission
- [x] Add execute permission with chmod
- [x] Run it successfully

### Commands I Used
nano hello.sh
./hello.sh
chmod +x hello.sh
./hello.sh

### My Output
Before chmod: -rw-r--r-- = Permission denied
After chmod:  -rwxr-xr-x = Hello DevOps

### What I Learned
Every script needs chmod +x before Linux will run it.
x means execute permission.
Without x = Permission denied always.

---

## Exercise 4: System Info ✅

### Tasks
- [x] Run system-info.sh script
- [x] Find disk space used by /var
- [x] Find which process uses most RAM

### Commands I Used
bash system-info.sh
du -sh /var
ps aux --sort=-%mem | head -6

### My Output
- /var disk usage = 1.3G
- Highest RAM process = VSCode Server at 4.3%
- My system = Ubuntu 22.04, 12 CPU cores, 3.5GB RAM

### What I Learned
df -h shows disk usage for whole system.
du -sh shows disk usage for one folder.
ps aux shows all running processes.
--sort=-%mem sorts by RAM usage highest first.

---

## Summary
All 4 exercises completed on Jun 21 2026.
Scripts written: system-info.sh, hello.sh
Key concepts learned:
- Linux file system structure
- File operations (create, copy, move, delete)
- File permissions (chmod)
- System information commands

