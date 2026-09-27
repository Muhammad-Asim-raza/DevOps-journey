"""Tests for GitLab CI Demo App"""
import sys, os, json, threading, time, urllib.request
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
import pytest
from src.app import H, START
from http.server import HTTPServer

PORT = 19200

@pytest.fixture(scope="module")
def server():
    httpd = HTTPServer(("127.0.0.1", PORT), H)
    t = threading.Thread(target=httpd.serve_forever, daemon=True)
    t.start()
    time.sleep(0.5)
    yield f"http://127.0.0.1:{PORT}"
    httpd.shutdown()

def get(url):
    with urllib.request.urlopen(url, timeout=5) as r:
        return r.status, json.loads(r.read())

def test_home(server):
    s, b = get(f"{server}/")
    assert s == 200 and b["service"] == "gitlab-ci-demo"

def test_health(server):
    s, b = get(f"{server}/health")
    assert s == 200 and b["status"] == "healthy"

def test_pipeline_info(server):
    s, b = get(f"{server}/pipeline")
    assert s == 200 and "pipeline_id" in b

def test_404(server):
    try:
        urllib.request.urlopen(f"{server}/missing", timeout=5)
    except urllib.error.HTTPError as e:
        assert e.code == 404

def test_health_has_timestamp(server):
    _, b = get(f"{server}/health")
    assert "time" in b
