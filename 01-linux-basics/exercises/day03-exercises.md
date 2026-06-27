# Day 3 Exercises — Process Management
**Date:** Jun 23 2026
**Status:** ✅ Completed

---

## Exercise 1: View Processes ✅
- [x] Run ps aux and see all processes
- [x] Find bash process using grep
- [x] Count total running processes

### Commands Used
ps aux
ps aux | grep bash
ps aux | wc -l

### What I Learned
- Every running program is a process
- ps aux shows ALL processes
- Each process has a unique PID number
- grep filters to find specific processes

---

## Exercise 2: Monitor Processes ✅
- [x] Run top and identify highest CPU process
- [x] Sort by memory with M key
- [x] Exit top with q

### Commands Used
top

### What I Learned
- top shows live updating process list
- M sorts by memory usage
- P sorts by CPU usage
- q exits top
- top is like Task Manager in Windows

---

## Exercise 3: Kill a Process ✅
- [x] Started sleep 1000 in background with &
- [x] Found PID using ps aux | grep sleep
- [x] Killed with kill -15
- [x] Verified it was gone

### Commands Used
sleep 1000 &
ps aux | grep sleep
kill -15 [PID]
ps aux | grep sleep

### What I Learned
- & runs process in background
- kill -15 stops process nicely
- kill -9 force stops process
- Always try -15 before -9

---

## Exercise 4: Services ✅
- [x] Checked SSH service status
- [x] Checked cron service status

### Commands Used
sudo systemctl status ssh
sudo systemctl status cron

### My Output
- SSH  = active (running) ✅
- Cron = active (running) ✅

### What I Learned
- systemctl manages all Linux services
- active (running) = service working
- inactive (dead) = service stopped
- enable = start automatically on boot

---

## Exercise 5: Cron Job ✅
- [x] Opened crontab with crontab -e
- [x] Added cron job running every minute
- [x] Verified it worked
- [x] Removed the cron job

### Cron Syntax I Learned
* * * * * command
│ │ │ │ └── Weekday
│ │ │ └──── Month
│ │ └────── Day
│ └──────── Hour
└────────── Minute

### Memory Trick
"My Hamster Drinks Morning Water"
 M     H       D       Mo     W

---

## Exercise 6: process-monitor.sh ✅
- [x] Script runs successfully
- [x] Output saved to script-output.txt

### What The Script Does
- Shows total running processes
- Shows top 5 CPU processes
- Shows top 5 memory processes
- Checks if SSH and cron are running
- Shows system load and memory

---

## Summary
All 6 exercises completed on Jun 23 2026.
Scripts written: process-monitor.sh
Key concepts learned:
- Processes (ps aux, top, kill)
- Services (systemctl)
- Background jobs (&, jobs, fg)
- Cron scheduling
