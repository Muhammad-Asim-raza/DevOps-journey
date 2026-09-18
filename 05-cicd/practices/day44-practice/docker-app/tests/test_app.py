"""Tests for CI/CD Docker Demo App"""
import sys
import os
sys.path.insert(0, os.path.join(
    os.path.dirname(__file__), '..'))

import json
import threading
import time
import urllib.request
import pytest


@pytest.fixture(scope="module")
def server():
    """Start test server"""
    from src.app import AppHandler
    from http.server import HTTPServer

    httpd = HTTPServer(("127.0.0.1", 18080), AppHandler)
    thread = threading.Thread(
        target=httpd.serve_forever, daemon=True
    )
    thread.start()
    time.sleep(0.5)
    yield "http://127.0.0.1:18080"
    httpd.shutdown()


def get(url):
    with urllib.request.urlopen(url, timeout=5) as r:
        return r.status, json.loads(r.read())


def test_home_returns_200(server):
    status, body = get(f"{server}/")
    assert status == 200
    assert body["service"] == "cicd-docker-demo"


def test_health_returns_healthy(server):
    status, body = get(f"{server}/health")
    assert status == 200
    assert body["status"] == "healthy"


def test_version_returns_build_info(server):
    status, body = get(f"{server}/version")
    assert status == 200
    assert "version" in body
    assert "commit" in body


def test_ready_returns_ready(server):
    status, body = get(f"{server}/ready")
    assert status == 200
    assert body["status"] == "ready"


def test_health_has_timestamp(server):
    _, body = get(f"{server}/health")
    assert "timestamp" in body


def test_home_has_build_info(server):
    _, body = get(f"{server}/")
    assert "build" in body
    assert "version" in body["build"]
