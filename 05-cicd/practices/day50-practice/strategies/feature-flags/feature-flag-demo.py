#!/usr/bin/env python3
"""
Feature Flags Implementation Demo
Author: Asim Raza - Day 50
Demonstrates: dark launching, percentage rollout
"""
import os
import hashlib
import json
from datetime import datetime
from http.server import HTTPServer, BaseHTTPRequestHandler


# ── Feature Flag Configuration ──────────────────
# In production: load from LaunchDarkly, Split.io,
# environment variables, or config service
FEATURE_FLAGS = {
    "new_checkout_flow": {
        "enabled": True,
        "rollout_percentage": 10,
        # 10% of users see new checkout
    },
    "dark_mode_ui": {
        "enabled": True,
        "rollout_percentage": 50,
        # 50% of users see dark mode
    },
    "ai_recommendations": {
        "enabled": False,
        # Completely disabled
    },
    "beta_api_v2": {
        "enabled": True,
        "rollout_percentage": 100,
        # Full rollout
    },
}


def is_feature_enabled(flag_name: str,
                       user_id: str) -> bool:
    """
    Check if a feature is enabled for a user.
    Consistent: same user always gets same result.
    """
    flag = FEATURE_FLAGS.get(flag_name)
    if not flag:
        return False
    if not flag.get("enabled", False):
        return False

    rollout_pct = flag.get("rollout_percentage", 100)
    if rollout_pct >= 100:
        return True

    # Hash user_id to get consistent 0-99 bucket
    # Same user ALWAYS in same bucket
    # Prevents: user seeing feature one request, not next
    hash_val = int(hashlib.md5(
        f"{user_id}:{flag_name}".encode()
    ).hexdigest(), 16)
    user_bucket = hash_val % 100

    return user_bucket < rollout_pct


class FeatureFlagHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        # Get user_id from header or use default
        user_id = self.headers.get(
            'X-User-ID', 'anonymous-user'
        )

        if self.path == '/health':
            self._json(200, {"status": "healthy"})

        elif self.path == '/':
            self._json(200, {
                "service": "feature-flag-demo",
                "user_id": user_id,
                "features": {
                    flag: is_feature_enabled(
                        flag, user_id
                    )
                    for flag in FEATURE_FLAGS
                },
                "timestamp": datetime.utcnow().isoformat()
            })

        elif self.path == '/checkout':
            # Feature flag controls which checkout to show
            if is_feature_enabled(
                "new_checkout_flow", user_id
            ):
                self._json(200, {
                    "checkout": "new_flow_v2",
                    "user": user_id,
                    "message": "Using new checkout! (10% rollout)",
                    "features": ["one_click", "apple_pay"]
                })
            else:
                self._json(200, {
                    "checkout": "classic_flow_v1",
                    "user": user_id,
                    "message": "Using classic checkout (90%)"
                })

        else:
            self._json(404, {"error": "not found"})

    def _json(self, code, data):
        body = json.dumps(data, indent=2).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", len(body))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *a): pass


if __name__ == '__main__':
    port = int(os.getenv("PORT", "8000"))
    print(f"Feature flag demo on :{port}", flush=True)
    HTTPServer(("0.0.0.0", port), FeatureFlagHandler).serve_forever()
