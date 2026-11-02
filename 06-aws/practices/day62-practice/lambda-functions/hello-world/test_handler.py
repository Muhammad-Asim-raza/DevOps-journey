"""
Tests for Lambda handler
Author: Asim Raza - Day 62
"""
import json
import os
import sys
from unittest.mock import MagicMock, patch

sys.path.insert(0, os.path.dirname(__file__))

import pytest

os.environ['BUCKET_NAME'] = 'test-bucket'
os.environ['ENVIRONMENT'] = 'test'


@pytest.fixture
def mock_context():
    ctx = MagicMock()
    ctx.function_name = "hello-world"
    ctx.aws_request_id = "test-request-id-123"
    ctx.memory_limit_in_mb = "512"
    ctx.get_remaining_time_in_millis.return_value = 25000
    ctx.log_stream_name = "2024/08/19/[$LATEST]abc"
    return ctx


class TestHandlerSuccess:
    def test_default_name(self, mock_context):
        from handler import handler
        resp = handler({}, mock_context)
        assert resp["statusCode"] == 200
        body = json.loads(resp["body"])
        assert "Hello, World!" in body["result"]["greeting"]

    def test_custom_name(self, mock_context):
        from handler import handler
        resp = handler({"name": "Asim"}, mock_context)
        assert resp["statusCode"] == 200
        body = json.loads(resp["body"])
        assert "Hello, Asim!" in body["result"]["greeting"]

    def test_response_has_request_id(self, mock_context):
        from handler import handler
        resp = handler({}, mock_context)
        assert resp["headers"]["X-Request-ID"] == "test-request-id-123"

    def test_response_has_timestamp(self, mock_context):
        from handler import handler
        resp = handler({}, mock_context)
        body = json.loads(resp["body"])
        assert "timestamp" in body


class TestHandlerValidation:
    def test_invalid_name_type(self, mock_context):
        from handler import handler
        resp = handler({"name": 123}, mock_context)
        assert resp["statusCode"] == 400

    def test_name_too_long(self, mock_context):
        from handler import handler
        resp = handler({"name": "x" * 101}, mock_context)
        assert resp["statusCode"] == 400


class TestContextUsage:
    def test_function_name_in_response(self, mock_context):
        from handler import handler
        resp = handler({"name": "Test"}, mock_context)
        body = json.loads(resp["body"])
        assert body["result"]["function"] == "hello-world"
