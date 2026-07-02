# Day 6 Exercises — Package Management & System Admin
**Date:** Jun 26 2026
**Status:** ✅ Completed

---

## Exercise 1: Package Management ✅
- [x] Ran apt update to refresh package list
- [x] Ran apt upgrade to install updates
- [x] Installed nginx with apt install
- [x] Searched for packages with apt search
- [x] Got package info with apt show
- [x] Listed installed packages with dpkg -l
- [x] Checked nginx files with dpkg -L nginx

### Commands Used
sudo apt update
sudo apt upgrade -y
sudo apt install nginx -y
apt search nginx
apt show nginx
dpkg -l | wc -l
dpkg -L nginx

### What I Learned
- apt update = refresh package list only
- apt upgrade = actually install updates
- apt install = install new software
- apt remove = remove but keep config
- apt purge = remove including config
- dpkg = low level package tool under apt
- dpkg -l = list all installed packages
- dpkg -L = list files of a package

---

## Exercise 2: Environment Variables ✅
- [x] Viewed all variables with env
- [x] Checked $HOME $USER $PATH $SHELL
- [x] Created custom environment variable
- [x] Made variables permanent in ~/.bashrc
- [x] Applied changes with source

### Commands Used
env
echo $HOME
echo $USER
echo $PATH
export MY_NAME="Asim Raza"
nano ~/.bashrc
source ~/.bashrc

### What I Learned
- Environment variables = system wide settings
- $ accesses variable value
- export makes variable available to programs
- ~/.bashrc = runs on every terminal open
- source = apply file without restarting

---

## Exercise 3: journalctl Logs ✅
- [x] Viewed all logs with journalctl -r
- [x] Filtered nginx logs with -u nginx
- [x] Watched live logs with -f
- [x] Filtered by time with --since
- [x] Filtered errors with -p err

### Commands Used
journalctl -r
journalctl -u nginx
journalctl -f
journalctl --since "1 hour ago"
journalctl -p err

### What I Learned
- journalctl = systemd journal viewer
- -r = newest logs first
- -u = filter by service name
- -f = follow live updates
- --since = filter by time
- -p err = show only errors

---

## Exercise 4: Disk and Network ✅
- [x] Checked disk usage with df -h
- [x] Checked folder sizes with du -sh
- [x] Checked IP with hostname -I
- [x] Checked open ports with ss -tlnp
- [x] Tested connectivity with ping

### Commands Used
df -h
du -sh ~/devops-journey
hostname -I
ss -tlnp
ping google.com

### What I Learned
- df -h shows filesystem disk usage
- du -sh shows folder disk usage
- hostname -I shows IP address
- ss -tlnp shows listening ports
- ping tests server reachability

---

## Exercise 5: System Admin Script ✅
- [x] Wrote sysadmin-tool.sh
- [x] Script checks packages, disk, network
- [x] Script checks service status
- [x] Output saved as proof

---

## Summary
All exercises completed on Jun 26 2026
Scripts written: sysadmin-tool.sh

Key concepts learned:
- Package management (apt, dpkg)
- Environment variables
- System logging (journalctl)
- Disk management (df, du)
- Network commands (ip, ss, ping)
