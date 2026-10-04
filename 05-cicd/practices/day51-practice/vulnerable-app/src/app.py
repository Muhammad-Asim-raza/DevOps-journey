#!/usr/bin/env python3
"""
Intentionally Vulnerable Demo App
Author: Asim Raza - Day 51
Purpose: Demonstrate what SAST scanning catches
WARNING: This code is intentionally insecure!
         DO NOT use in production!
"""
import os
import sqlite3
import subprocess
import hashlib
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs


# ❌ VULNERABILITY 1: Hardcoded secret
# SAST/Secret scanner catches this
API_KEY = "sk-prod-abc123def456ghi789"
DB_PASSWORD = "super_secret_prod_password"
AWS_SECRET = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"


class VulnerableHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        parsed = urlparse(self.path)
        params = parse_qs(parsed.query)

        if parsed.path == '/search':
            self._search(params)
        elif parsed.path == '/run':
            self._run_command(params)
        elif parsed.path == '/user':
            self._get_user(params)
        elif parsed.path == '/hash':
            self._weak_hash(params)
        elif parsed.path == '/health':
            self._json(200, {"status": "ok"})
        else:
            self._json(200, {"service": "vulnerable-demo"})

    def _search(self, params):
        """
        ❌ VULNERABILITY 2: SQL Injection
        User input directly concatenated into SQL
        SAST (bandit) catches: B608 hardcoded_sql_expressions
        Attacker: ?q=' OR '1'='1 → dumps all users
        """
        query = params.get('q', [''])[0]
        conn = sqlite3.connect(':memory:')
        # WRONG - directly concatenating user input:
        sql = f"SELECT * FROM users WHERE name = '{query}'"
        # RIGHT would be:
        # cursor.execute("SELECT * FROM users WHERE name = ?", (query,))
        self._json(200, {"query": sql, "warning": "SQL injection demo"})

    def _run_command(self, params):
        """
        ❌ VULNERABILITY 3: Command Injection
        User input passed to shell
        SAST (bandit) catches: B602 subprocess_popen_with_shell_equals_true
        Attacker: ?cmd=ls; cat /etc/passwd
        """
        cmd = params.get('cmd', ['echo hello'])[0]
        # WRONG - shell=True with user input:
        result = subprocess.run(
            cmd, shell=True,      # ← DANGEROUS!
            capture_output=True,
            text=True, timeout=5
        )
        self._json(200, {
            "output": result.stdout[:100],
            "warning": "Command injection demo"
        })

    def _get_user(self, params):
        """
        ❌ VULNERABILITY 4: Path Traversal
        User controls file path
        SAST catches: open() with user-controlled path
        Attacker: ?file=../../etc/passwd
        """
        filename = params.get('file', ['data.txt'])[0]
        # WRONG - no path validation:
        try:
            with open(f"/app/data/{filename}") as f:
                content = f.read(200)
        except FileNotFoundError:
            content = "File not found"
        self._json(200, {
            "file": filename,
            "content": content,
            "warning": "Path traversal demo"
        })

    def _weak_hash(self, params):
        """
        ❌ VULNERABILITY 5: Weak Cryptography
        MD5 and SHA1 are broken for passwords
        SAST (bandit) catches: B324 hashlib
        """
        password = params.get('p', ['test'])[0]
        # WRONG - MD5 for passwords:
        md5_hash = hashlib.md5(password.encode()).hexdigest()
        # RIGHT would be: bcrypt, argon2, scrypt
        self._json(200, {
            "hash": md5_hash,
            "algorithm": "MD5 (BROKEN!)",
            "warning": "Use bcrypt instead"
        })

    def _json(self, code, data):
        import json
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *a):
        pass


if __name__ == '__main__':
    print("⚠️  WARNING: Intentionally vulnerable app!")
    print("    For security scanning DEMO only!")
    HTTPServer(("0.0.0.0", 8000), VulnerableHandler).serve_forever()
