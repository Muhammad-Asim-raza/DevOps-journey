"""
Comprehensive test suite — DevOps CI/CD Platform
Author: Asim Raza - Day 52
"""
import json
import sys
import os
import threading
import time
import urllib.request
import urllib.error

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import pytest
from src.app import PlatformHandler, metrics, BUILD
from http.server import HTTPServer

PORT = 19520


@pytest.fixture(scope="module")
def server():
    httpd = HTTPServer(("127.0.0.1", PORT), PlatformHandler)
    t = threading.Thread(target=httpd.serve_forever, daemon=True)
    t.start()
    time.sleep(0.5)
    yield f"http://127.0.0.1:{PORT}"
    httpd.shutdown()


def get(url, timeout=5):
    with urllib.request.urlopen(url, timeout=timeout) as r:
        return r.status, json.loads(r.read())


# ── Home endpoint ──────────────────────────────────────────

class TestHomeEndpoint:
    def test_home_returns_200(self, server):
        s, b = get(f"{server}/")
        assert s == 200

    def test_home_has_service_name(self, server):
        _, b = get(f"{server}/")
        assert b["service"] == "devops-cicd-platform"

    def test_home_has_author(self, server):
        _, b = get(f"{server}/")
        assert b["author"] == "Asim Raza"

    def test_home_has_build_info(self, server):
        _, b = get(f"{server}/")
        assert "build" in b
        assert "version" in b["build"]

    def test_home_has_uptime(self, server):
        _, b = get(f"{server}/")
        assert b["uptime_s"] >= 0


# ── Health endpoints ───────────────────────────────────────

class TestHealthEndpoints:
    def test_health_returns_200(self, server):
        s, b = get(f"{server}/health")
        assert s == 200
        assert b["status"] == "healthy"

    def test_health_has_timestamp(self, server):
        _, b = get(f"{server}/health")
        assert "timestamp" in b

    def test_health_has_version(self, server):
        _, b = get(f"{server}/health")
        assert "version" in b

    def test_ready_returns_200(self, server):
        s, b = get(f"{server}/ready")
        assert s == 200
        assert b["status"] == "ready"

    def test_live_returns_200(self, server):
        s, b = get(f"{server}/live")
        assert s == 200
        assert b["status"] == "alive"

    def test_live_has_uptime(self, server):
        _, b = get(f"{server}/live")
        assert b["uptime_s"] >= 0


# ── Metrics ────────────────────────────────────────────────

class TestMetrics:
    def test_metrics_returns_200(self, server):
        with urllib.request.urlopen(
            f"{server}/metrics", timeout=5
        ) as r:
            assert r.status == 200

    def test_metrics_prometheus_format(self, server):
        with urllib.request.urlopen(
            f"{server}/metrics", timeout=5
        ) as r:
            body = r.read().decode()
            assert "requests_total" in body
            assert "# HELP" in body
            assert "# TYPE" in body

    def test_status_endpoint(self, server):
        s, b = get(f"{server}/status")
        assert s == 200
        assert "requests_total" in b
        assert "errors_total" in b


# ── Build info ─────────────────────────────────────────────

class TestBuildInfo:
    def test_build_info_returns_200(self, server):
        s, b = get(f"{server}/build")
        assert s == 200

    def test_build_has_required_fields(self, server):
        _, b = get(f"{server}/build")
        required = ["version", "commit", "branch",
                    "build_num", "built_by"]
        for field in required:
            assert field in b, f"Missing field: {field}"


# ── Error handling ─────────────────────────────────────────

class TestErrorHandling:
    def test_unknown_path_returns_404(self, server):
        try:
            urllib.request.urlopen(
                f"{server}/nonexistent", timeout=5
            )
            assert False, "Should have raised"
        except urllib.error.HTTPError as e:
            assert e.code == 404

    def test_404_includes_endpoints(self, server):
        try:
            urllib.request.urlopen(
                f"{server}/missing", timeout=5
            )
        except urllib.error.HTTPError as e:
            body = json.loads(e.read())
            assert "endpoints" in body


# ── Metrics tracking ───────────────────────────────────────

class TestMetricsTracking:
    def test_request_count_increases(self, server):
        before = metrics["requests_total"]
        get(f"{server}/health")
        get(f"{server}/health")
        after = metrics["requests_total"]
        assert after > before
