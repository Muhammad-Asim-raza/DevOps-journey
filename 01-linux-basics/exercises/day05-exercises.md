# Day 5 Exercises — SSH Mastery
**Date:** Jun 25 2026
**Status:** ✅ Completed

---

## Exercise 1: SSH Keys ✅
- [x] Checked SSH folder with ls -la ~/.ssh
- [x] Generated SSH key pair
- [x] Viewed public key with cat

### Commands Used
ls -la ~/.ssh
ssh-keygen -t ed25519 -C "asim@devops-journey"
cat ~/.ssh/id_ed25519.pub

### What I Learned
- Private key stays on MY computer forever
- Public key goes on every server I access
- ed25519 is modern and secure
- Never share private key with anyone

---

## Exercise 2: SSH Config File ✅
- [x] Created ~/.ssh/config
- [x] Added server shortcuts
- [x] Fixed permissions chmod 600

### What I Learned
- SSH config creates shortcuts for servers
- Instead of long command = ssh production
- chmod 600 required on config file

---

## Exercise 3: SCP File Transfer ✅
- [x] Learned scp syntax
- [x] Understood copy to and from server

### Commands Used
scp file.txt ubuntu@server:/home/ubuntu/
scp ubuntu@server:/home/ubuntu/file.txt ~/

### What I Learned
- SCP copies files securely over SSH
- -r flag copies entire folders
- Source first then destination always

---

## Exercise 4: SSH Script ✅
- [x] Wrote ssh-checker.sh
- [x] Script checks all SSH components
- [x] Output saved as proof

---

## Summary
All exercises completed on Jun 25 2026
Scripts written: ssh-checker.sh

Key concepts learned:
- SSH key pairs (private + public)
- Connecting to remote servers
- SSH config file shortcuts
- SCP for secure file transfer
- chmod requirements for SSH files
