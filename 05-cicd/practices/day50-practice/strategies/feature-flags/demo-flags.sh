#!/bin/bash
# ================================================
# Feature Flags Demo
# Author: Asim Raza - Day 50
# ================================================

echo "============================================"
echo "  FEATURE FLAGS DEMO"
echo "============================================"

echo ""
echo "[ What are Feature Flags? ]"
echo ""
echo "  Code deployed to production but feature is OFF"
echo "  Enable for specific users or percentages"
echo "  Decouple: DEPLOYMENT from RELEASE"
echo ""
echo "  Traditional:"
echo "  Deploy code = feature enabled for everyone"
echo ""
echo "  Feature flags:"
echo "  Deploy code + flag = OFF (no users affected)"
echo "  Enable for 1% → monitor → 10% → 100%"
echo "  Disable instantly if problems found"

echo ""
echo "[ Feature Flag Types ]"
echo ""
echo "  1. Kill switch (on/off):"
echo "  FEATURE_NEW_DASHBOARD=false"
echo "  Instantly disable broken features"
echo ""
echo "  2. Percentage rollout:"
echo "  CHECKOUT_V2_ROLLOUT=10"
echo "  10% of users see new checkout"
echo ""
echo "  3. User targeting:"
echo "  BETA_USERS=[user123, user456]"
echo "  Only specific users see feature"
echo ""
echo "  4. A/B testing:"
echo "  BUTTON_COLOR_TEST=50"
echo "  50% see red button, 50% see green"
echo "  Measure conversion rate difference"

echo ""
echo "[ Testing the feature flag logic ]"
echo ""

# Demonstrate consistent hashing
python3 << 'PYEOF'
import hashlib

def bucket(user_id, flag_name):
    hash_val = int(hashlib.md5(
        f"{user_id}:{flag_name}".encode()
    ).hexdigest(), 16)
    return hash_val % 100

FLAG = "new_checkout_flow"
ROLLOUT = 10  # 10%

users = [f"user-{i:04d}" for i in range(1, 21)]
enabled = [u for u in users if bucket(u, FLAG) < ROLLOUT]
disabled = [u for u in users if bucket(u, FLAG) >= ROLLOUT]

print(f"Flag: {FLAG} ({ROLLOUT}% rollout)")
print(f"Sample users: {len(users)}")
print(f"Flag ON  ({len(enabled)}/{len(users)}): {enabled}")
print(f"Flag OFF ({len(disabled)}/{len(users)}): {disabled[:5]}...")
print()
print("Same user always gets same result:")
for user in enabled[:3]:
    b = bucket(user, FLAG)
    print(f"  {user}: bucket {b} (< {ROLLOUT} = ON)")
PYEOF

echo ""
echo "[ Feature Flag Tools ]"
echo ""
echo "  Open Source:"
echo "  - Unleash (self-hosted)"
echo "  - Flagsmith (self-hosted or cloud)"
echo "  - GrowthBook (self-hosted)"
echo ""
echo "  Commercial:"
echo "  - LaunchDarkly (industry standard)"
echo "  - Split.io"
echo "  - Optimizely"
echo "  - AWS AppConfig (for AWS users)"
echo ""
echo "  DIY:"
echo "  - Environment variables"
echo "  - Database table (flags table)"
echo "  - Config service (consul, etcd)"

echo ""
echo "[ Feature Flags in CI/CD Pipeline ]"
echo ""
echo "  1. Deploy: code in production (flag OFF)"
echo "     git push → pipeline → deploy"
echo "     Zero user impact"
echo ""
echo "  2. Enable for internal team:"
echo "     Flag: beta_users=[engineer1, engineer2]"
echo "     Internal testing on production"
echo ""
echo "  3. Enable for 1% of users:"
echo "     Flag: new_feature_rollout=1"
echo "     Monitor error rates, performance"
echo ""
echo "  4. Gradual rollout:"
echo "     1% → 5% → 25% → 50% → 100%"
echo "     Or rollback: set to 0% instantly"
echo ""
echo "  5. Full rollout: remove flag from code"
echo "     Clean up: no dead code"

echo ""
echo "============================================"
echo "  FEATURE FLAGS DEMO COMPLETE"
echo "============================================"
