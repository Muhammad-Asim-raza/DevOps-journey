# Day 10 Exercises — Cron Jobs Systemd Automation
**Date:** Jun 30 2026
**Status:** ✅ Completed

---

## Exercise 1: Cron Jobs ✅
- [x] Learned crontab syntax (5 fields)
- [x] Added test cron job running every minute
- [x] Verified cron output in log file
- [x] Removed test cron job
- [x] Learned special schedules @daily @weekly

### Proof
See: practices/day10-practice/exercise1-proof.txt

### Cron Syntax Reference
* * * * * command
│ │ │ │ └── Weekday (0-7)
│ │ │ └──── Month (1-12)
│ │ └────── Day (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)

### Real Cron Jobs I Can Now Write
0 0 * * * backup.sh         (midnight daily)
0 9 * * 1 report.sh         (Monday 9am)
*/15 * * * * monitor.sh     (every 15 min)
@reboot startup.sh          (on boot)
@daily cleanup.sh           (every day)

### What I Learned
- cron = alarm clock for Linux servers
- crontab -e = edit my cron jobs
- crontab -l = list my cron jobs
- Always use full paths in cron
- Always log output with >> log 2>&1
- Test scripts manually before adding to cron
- Check cron logs: grep CRON /var/log/syslog

---

## Exercise 2: Systemd Services ✅
- [x] Created monitor.sh script
- [x] Created devops-monitor.service file
- [x] Used daemon-reload to register service
- [x] Started service with systemctl start
- [x] Enabled service with systemctl enable
- [x] Checked status with systemctl status
- [x] Viewed logs with journalctl -u

### Proof
See: practices/day10-practice/exercise2-proof.txt

### Service File Structure
[Unit]
Description=What this service does
After=network.target

[Service]
Type=simple
User=username
ExecStart=/full/path/to/script.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target

### Key Commands
sudo systemctl daemon-reload
sudo systemctl start service-name
sudo systemctl stop service-name
sudo systemctl restart service-name
sudo systemctl enable service-name
sudo systemctl disable service-name
sudo systemctl status service-name
journalctl -u service-name -f

### What I Learned
- systemd manages ALL services on Linux
- Services run forever in background
- Restart=always means auto-recovery from crashes
- enable = start on boot (NOT same as start)
- start = run now
- daemon-reload MUST run after editing service files
- journalctl shows service logs

---

## Exercise 3: Systemd Timers ✅
- [x] Created disk-check.service file
- [x] Created disk-check.timer file
- [x] Enabled and started timer
- [x] Listed active timers

### Proof
See: practices/day10-practice/exercise3-proof.txt

### Timer vs Cron
Use cron for: simple recurring tasks
Use timers for: tasks needing logging/dependencies

### What I Learned
- Timers need TWO files: service + timer
- OnBootSec = delay after boot
- OnUnitActiveSec = repeat interval
- systemctl list-timers shows all timers
- Timers log to journald automatically

---

## Exercise 4: at Command ✅
- [x] Scheduled one-time task with at
- [x] Listed pending jobs with atq
- [x] Learned to remove jobs with atrm

### Proof
See: practices/day10-practice/exercise4-proof.txt

### Key Commands
echo "command" | at 11:00 PM
echo "command" | at now + 5 minutes
echo "command" | at tomorrow
atq     = list pending jobs
atrm 3  = remove job number 3

### Cron vs at
cron = recurring (every day/week/month)
at   = one-time (run once at specific time)

---

## Exercise 5: Automation Suite ✅
- [x] Created health-check.sh
- [x] Created backup.sh
- [x] Created cleanup-logs.sh
- [x] Created daily-report.sh
- [x] All scripts tested and working
- [x] Full crontab setup documented

### Proof
See: practices/day10-practice/automation-suite.sh
See: practices/day10-practice/script-output-automation.txt

---

## Automation Best Practices I Learned
- Always use full paths in cron/systemd
- Always log output to file (>> log 2>&1)
- Test scripts manually before automating
- Use Restart=always for critical services
- Use @reboot for startup scripts
- Monitor automation logs regularly
- Set MAILTO in crontab for email alerts
- Use systemd timers for complex scheduling

---

## Summary
All 5 exercises completed on Jun 30 2026

Scripts written:
- cron-manager.sh (cron reference tool)
- automation-suite.sh (complete setup)
- monitor.sh (systemd service script)
- automation-scripts/health-check.sh
- automation-scripts/backup.sh
- automation-scripts/cleanup-logs.sh
- automation-scripts/daily-report.sh

Proof files:
- exercise1-proof.txt (cron jobs)
- exercise2-proof.txt (systemd service)
- exercise3-proof.txt (systemd timer)
- exercise4-proof.txt (at command)
- script-output-cron.txt
- script-output-automation.txt

Key concepts learned:
- Cron jobs (scheduling recurring tasks)
- Crontab syntax (5 fields)
- Special schedules (@daily @weekly @reboot)
- Systemd services (run forever)
- Service file anatomy
- Systemd timers (modern cron)
- at command (one-time tasks)
- Linux automation best practices
