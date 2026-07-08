# Day 9 Exercises — Linux Users Groups Permissions Security
**Date:** Jun 29 2026
**Status:** ✅ Completed

---

## Exercise 1: User Information ✅
- [x] Checked current user with whoami
- [x] Checked user and group IDs with id
- [x] Read /etc/passwd entry for my user
- [x] Listed all regular users on system

### Proof
See: practices/day09-practice/exercise1-proof.txt

### Key Commands
whoami
id
cat /etc/passwd | grep asim_raza
awk -F: '$3 >= 1000 {print $1}' /etc/passwd

### What I Learned
- Every user has a unique UID number
- Root always has UID 0
- System users have UID 1-999
- Regular users have UID 1000+
- /etc/passwd stores user information
- /etc/shadow stores encrypted passwords

---

## Exercise 2: User Management ✅
- [x] Created new user with useradd -m -s -c
- [x] Set password with passwd
- [x] Modified user with usermod
- [x] Locked user with usermod -L
- [x] Verified user exists with id

### Proof
See: practices/day09-practice/exercise2-proof.txt

### Key Commands
sudo useradd -m -s /bin/bash -c "Name" username
sudo passwd username
sudo usermod -c "New Name" username
sudo usermod -L username
sudo userdel -r username

### What I Learned
- useradd creates new user accounts
- -m creates home directory
- -s sets the login shell
- usermod modifies existing users
- -L locks account (employee leaves)
- -r removes home directory with userdel
- Always use -aG never -G alone

---

## Exercise 3: Group Management ✅
- [x] Created group with groupadd
- [x] Added user to group with usermod -aG
- [x] Verified group membership with groups
- [x] Read /etc/group entry

### Proof
See: practices/day09-practice/exercise3-proof.txt

### Key Commands
sudo groupadd groupname
sudo usermod -aG groupname username
groups username
cat /etc/group | grep groupname

### What I Learned
- Groups allow permission management at scale
- -aG = append to group (always use this)
- Never use -G alone (removes other groups)
- /etc/group stores all group information
- Primary group vs supplementary groups

---

## Exercise 4: File Permissions ✅
- [x] Read permission notation rwxr-xr--
- [x] Used chmod 755 644 600 400
- [x] Used chmod +x to add execute
- [x] Used chown to change ownership
- [x] Understood directory permissions

### Proof
See: practices/day09-practice/exercise4-proof.txt

### Permission Reference
r=4 w=2 x=1
755 = rwxr-xr-x (scripts)
644 = rw-r--r-- (regular files)
600 = rw------- (private files)
400 = r-------- (AWS .pem keys)
777 = NEVER USE IN PRODUCTION

### What I Learned
- First char: - file d directory l link
- 3 groups: owner group others
- r=read w=write x=execute for files
- r=list w=create/delete x=enter for dirs
- chown changes ownership
- -R applies recursively to all files

---


--

### Proof
See: practices/day09-practice/user-manager.sh
See: practices/day09-practice/security-checker.sh
See: practices/day09-practice/script-output-users.txt
See: practices/day09-practice/script-output-security.txt

### What Scripts Do
user-manager.sh:
- Shows current user info
- Lists all users on system
- Shows sudo users
- Shows logged in users
- Shows recent logins

---

## Security Best Practices I Learned ✅
- Never use root for daily work
- Principle of least privilege
- SSH: disable root login
- SSH: disable password auth
- SSH: use keys only
- Firewall: default deny incoming
- chmod 777 = never in production
- Lock accounts when employees leave
- Review sudo logs regularly
- Monitor failed login attempts

---

## Summary
All 3 exercises completed on Jun 29 2026

Scripts written:
- user-manager.sh

Proof files:
- exercise1-proof.txt (user info)
- exercise2-proof.txt (user management)
- exercise3-proof.txt (group management)
- script-output-users.txt

Key concepts learned:
- User types (root system regular)
- User management (useradd usermod userdel)
- Group management (groupadd groupdel)
- File permissions (rwx chmod chown)
- sudo and sudoers
- Security best practices
