"""Tests for Jenkins Demo App"""
import sys, os, json, threading, time, urllib.request
sys.path.insert(0, os.path.join(os.path.dirname(__file__),'..'))
import pytest
from src.app import Handler
from http.server import HTTPServer

PORT = 19090

@pytest.fixture(scope="module")
def server():
    httpd = HTTPServer(("127.0.0.1", PORT), Handler)
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
    assert s == 200
    assert b["service"] == "jenkins-demo"

def test_health(server):
    s, b = get(f"{server}/health")
    assert s == 200
    assert b["status"] == "healthy"

def test_build_info(server):
    s, b = get(f"{server}/build")
    assert s == 200
    assert "version" in b

def test_health_has_time(server):
    _, b = get(f"{server}/health")
    assert "time" in b

def test_uptime_positive(server):
    _, b = get(f"{server}/")
    assert b["uptime"] >= 0
