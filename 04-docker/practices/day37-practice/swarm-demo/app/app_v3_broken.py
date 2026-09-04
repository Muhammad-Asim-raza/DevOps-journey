#!/usr/bin/env python3
import time
# Simulate broken app - exits immediately
print("FATAL: Database connection failed!")
time.sleep(1)
exit(1)  # Non-zero exit = broken
