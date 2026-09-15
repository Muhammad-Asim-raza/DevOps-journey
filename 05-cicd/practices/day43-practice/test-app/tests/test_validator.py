"""
test_validator.py
Tests for validator module
Author: Asim Raza - Day 43
"""
import pytest
import sys, os
sys.path.insert(0, os.path.join(
    os.path.dirname(__file__), '..'))

from src.validator import (
    validate_email,
    validate_ip,
    validate_port,
    sanitize_string,
    validate_url,
)


class TestEmailValidation:

    def test_valid_email_simple(self):
        assert validate_email("user@example.com") is True

    def test_valid_email_subdomain(self):
        assert validate_email("user@mail.example.com") is True

    def test_valid_email_plus(self):
        assert validate_email("user+tag@example.com") is True

    def test_invalid_no_at(self):
        assert validate_email("userexample.com") is False

    def test_invalid_no_domain(self):
        assert validate_email("user@") is False

    def test_invalid_empty(self):
        assert validate_email("") is False

    def test_invalid_not_string(self):
        assert validate_email(123) is False

    def test_invalid_spaces(self):
        assert validate_email("user @example.com") is False


class TestIPValidation:

    def test_valid_ip_loopback(self):
        assert validate_ip("127.0.0.1") is True

    def test_valid_ip_broadcast(self):
        assert validate_ip("255.255.255.255") is True

    def test_valid_ip_zero(self):
        assert validate_ip("0.0.0.0") is True

    def test_invalid_out_of_range(self):
        assert validate_ip("256.0.0.1") is False

    def test_invalid_too_few_octets(self):
        assert validate_ip("192.168.1") is False

    def test_invalid_letters(self):
        assert validate_ip("abc.def.ghi.jkl") is False

    def test_invalid_not_string(self):
        assert validate_ip(12345) is False


class TestPortValidation:

    def test_valid_http(self):
        assert validate_port(80) is True

    def test_valid_https(self):
        assert validate_port(443) is True

    def test_valid_max(self):
        assert validate_port(65535) is True

    def test_valid_min(self):
        assert validate_port(1) is True

    def test_invalid_zero(self):
        assert validate_port(0) is False

    def test_invalid_too_large(self):
        assert validate_port(65536) is False

    def test_valid_string_number(self):
        assert validate_port("8080") is True

    def test_invalid_letters(self):
        assert validate_port("abc") is False


class TestSanitizeString:

    def test_normal_string(self):
        assert sanitize_string("hello world") == "hello world"

    def test_truncation(self):
        result = sanitize_string("x" * 300, max_length=255)
        assert len(result) == 255

    def test_custom_max_length(self):
        result = sanitize_string("hello world", max_length=5)
        assert len(result) == 5

    def test_not_string_raises(self):
        with pytest.raises(TypeError):
            sanitize_string(123)

    def test_removes_null_bytes(self):
        result = sanitize_string("hello\x00world")
        assert "\x00" not in result


class TestURLValidation:

    def test_valid_http(self):
        assert validate_url("http://example.com") is True

    def test_valid_https(self):
        assert validate_url("https://example.com") is True

    def test_valid_with_path(self):
        assert validate_url("https://example.com/path") is True

    def test_invalid_no_scheme(self):
        assert validate_url("example.com") is False

    def test_invalid_ftp(self):
        assert validate_url("ftp://example.com") is False

    def test_invalid_not_string(self):
        assert validate_url(123) is False
