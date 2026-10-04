#!/bin/bash
# ================================================
# 01-sast-bandit.sh
# SAST Scanning with Bandit (Python)
# Author: Asim Raza - Day 51
# ================================================
set -euo pipefail

APP_DIR="${1:-vulnerable-app/src}"
OUTPUT_DIR="${2:-scan-results}"
mkdir -p "$OUTPUT_DIR"

echo "============================================"
echo "   SAST SCANNING WITH BANDIT"
echo "   Static Application Security Testing"
echo "============================================"
echo ""
echo "Target: $APP_DIR"
echo "Time:   $(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Install bandit if needed
pip install bandit --quiet 2>/dev/null

echo ""
echo "[ Running Bandit SAST Scan ]"
echo ""

# Run bandit and capture output
bandit \
    -r "$APP_DIR" \
    -f txt \
    -o "$OUTPUT_DIR/bandit-report.txt" \
    --severity-level low \
    --confidence-level low \
    -v \
    2>&1 || true

# Also generate JSON for processing
bandit \
    -r "$APP_DIR" \
    -f json \
    -o "$OUTPUT_DIR/bandit-report.json" \
    --severity-level low \
    2>/dev/null || true

# Parse and display results
echo ""
echo "[ Scan Results Summary ]"

if [ -f "$OUTPUT_DIR/bandit-report.json" ]; then
    python3 << PYEOF
import json, sys

try:
    with open("$OUTPUT_DIR/bandit-report.json") as f:
        data = json.load(f)

    results = data.get("results", [])
    metrics = data.get("metrics", {})

    severity_count = {"HIGH": 0, "MEDIUM": 0, "LOW": 0}
    for r in results:
        sev = r.get("issue_severity", "LOW")
        severity_count[sev] = severity_count.get(sev, 0) + 1

    print(f"  Total issues:   {len(results)}")
    print(f"  HIGH severity:  {severity_count.get('HIGH', 0)}")
    print(f"  MEDIUM severity:{severity_count.get('MEDIUM', 0)}")
    print(f"  LOW severity:   {severity_count.get('LOW', 0)}")

    print()
    print("  Issues found:")
    for r in results[:10]:  # Show first 10
        print(f"  [{r.get('issue_severity','?'):6s}] "
              f"Line {r.get('line_number','?'):4} - "
              f"{r.get('issue_text','?')[:60]}")

    # Security gate
    high_count = severity_count.get("HIGH", 0)
    if high_count > 0:
        print()
        print(f"  ❌ GATE FAILED: {high_count} HIGH severity issues")
        print(f"  Fix HIGH severity before deploying!")
        sys.exit(1)
    else:
        print()
        print("  ✅ GATE PASSED: No HIGH severity issues")
except Exception as e:
    print(f"  Parse error: {e}")
PYEOF
else
    cat "$OUTPUT_DIR/bandit-report.txt" 2>/dev/null | \
        grep -E "Issue:|Severity:|Confidence:" | head -20 || \
        echo "  No report generated"
fi

echo ""
echo "[ What SAST Scans For ]"
echo "  B101: assert statements (bypass-able)"
echo "  B102: exec() usage"
echo "  B105-B107: hardcoded passwords"
echo "  B108: probable temp file"
echo "  B201-B202: Flask debug mode"
echo "  B301-B323: deserialization issues"
echo "  B324: MD5/SHA1 for hashing"
echo "  B501-B507: SSL/TLS issues"
echo "  B601-B614: injection vulnerabilities"
echo "  B701-B703: Jinja2 template injection"

echo ""
echo "[ SAST in CI/CD Pipeline ]"
echo "  # GitHub Actions step:"
echo "  - name: SAST Scan"
echo "    run: |"
echo "      pip install bandit"
echo "      bandit -r src/ -ll -ii"
echo "      # -ll = only LOW and above"
echo "      # -ii = only MEDIUM confidence and above"
echo "      # exit code 1 if issues found → fails pipeline"
echo ""
echo "  Quality gate:"
echo "  HIGH severity found   → FAIL pipeline"
echo "  MEDIUM severity found → WARNING (review)"
echo "  LOW severity found    → INFO only"

echo ""
echo "============================================"
echo "   SAST SCAN COMPLETE"
echo "   Report: $OUTPUT_DIR/bandit-report.txt"
echo "============================================"
