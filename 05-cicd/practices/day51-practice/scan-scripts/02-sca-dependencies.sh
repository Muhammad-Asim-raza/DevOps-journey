#!/bin/bash
# ================================================
# 02-sca-dependencies.sh
# Software Composition Analysis
# Author: Asim Raza - Day 51
# ================================================
set -euo pipefail

REQ_FILE="${1:-vulnerable-app/requirements.txt}"
OUTPUT_DIR="${2:-scan-results}"
mkdir -p "$OUTPUT_DIR"

echo "============================================"
echo "   SCA - SOFTWARE COMPOSITION ANALYSIS"
echo "   Scanning dependencies for CVEs"
echo "============================================"
echo ""
echo "Requirements: $REQ_FILE"

# ── Method 1: Safety ────────────────────────────
echo ""
echo "[ Method 1: Safety Check ]"
pip install safety --quiet 2>/dev/null

safety check \
    -r "$REQ_FILE" \
    --output text \
    2>/dev/null | \
    tee "$OUTPUT_DIR/safety-report.txt" || \
    echo "  Safety check complete (may have found issues)"

echo ""
echo "[ Safety JSON Report ]"
safety check \
    -r "$REQ_FILE" \
    --output json \
    2>/dev/null > \
    "$OUTPUT_DIR/safety-report.json" || true

# Parse safety JSON
python3 << 'PYEOF' 2>/dev/null || echo "  JSON parsing skipped"
import json

try:
    with open("scan-results/safety-report.json") as f:
        data = json.load(f)

    vulns = data if isinstance(data, list) else \
            data.get("vulnerabilities", [])

    if not vulns:
        print("  ✅ No known vulnerabilities found")
    else:
        print(f"  ⚠️  Found {len(vulns)} vulnerability/ies:")
        for v in vulns[:5]:
            if isinstance(v, (list, tuple)) and len(v) >= 5:
                pkg = v[0]; version = v[2]; cve = v[4]
                print(f"    {pkg} {version}: {str(cve)[:80]}")
            elif isinstance(v, dict):
                pkg = v.get("package_name", "?")
                ver = v.get("analyzed_version", "?")
                ids = v.get("vulnerability_id", "?")
                print(f"    {pkg} {ver}: {ids}")
except Exception as e:
    print(f"  Parse error: {e}")
PYEOF

# ── Method 2: pip-audit ─────────────────────────
echo ""
echo "[ Method 2: pip-audit (modern, recommended) ]"
pip install pip-audit --quiet 2>/dev/null

pip-audit \
    -r "$REQ_FILE" \
    --format json \
    -o "$OUTPUT_DIR/pip-audit-report.json" \
    2>/dev/null || true

pip-audit \
    -r "$REQ_FILE" \
    2>/dev/null | \
    tee "$OUTPUT_DIR/pip-audit-report.txt" || \
    echo "  pip-audit scan complete"

echo ""
echo "[ npm audit (for Node.js projects) ]"
echo "  npm audit                    # check vulnerabilities"
echo "  npm audit --json             # JSON output"
echo "  npm audit fix                # auto-fix safe updates"
echo "  npm audit fix --force        # force all updates"
echo "  npm audit --audit-level=high # only HIGH+"

echo ""
echo "[ CVE Severity Levels ]"
echo "  CRITICAL: CVSS 9.0-10.0  → Fix immediately"
echo "  HIGH:     CVSS 7.0-8.9   → Fix within 24-72 hours"
echo "  MEDIUM:   CVSS 4.0-6.9   → Fix next sprint"
echo "  LOW:      CVSS 0.1-3.9   → Fix when convenient"
echo "  NONE:     CVSS 0.0       → Informational"

echo ""
echo "[ SCA in CI/CD Pipeline ]"
echo "  # GitHub Actions:"
echo "  - name: SCA Scan"
echo "    run: |"
echo "      pip install pip-audit"
echo "      pip-audit -r requirements.txt \\"
echo "        --vulnerability-service pypi \\"
echo "        --format json \\"
echo "        -o sca-results.json"
echo ""
echo "  Quality gate:"
echo "  CRITICAL CVE in dependency → FAIL pipeline"
echo "  HIGH CVE                   → WARNING or FAIL"
echo "  MEDIUM CVE                 → Track and schedule"

echo ""
echo "[ Fix strategies ]"
echo "  Pin to fixed version: requests==2.31.0"
echo "  Update: pip install --upgrade package"
echo "  Replace: find alternative without CVE"
echo "  Accept risk: document with justification"
echo "               (for internal/air-gapped use)"

echo ""
echo "============================================"
echo "   SCA SCAN COMPLETE"
echo "   Reports in: $OUTPUT_DIR/"
echo "============================================"
