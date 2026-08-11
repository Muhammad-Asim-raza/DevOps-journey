# Tests for sample app
# These run automatically in GitHub Actions
# Author: Asim Raza - Day 23

import pytest
from app import add, subtract, multiply, divide, greet, health_check

class TestMath:
    def test_add_positive(self):
        assert add(2, 3) == 5

    def test_add_negative(self):
        assert add(-1, -2) == -3

    def test_add_zero(self):
        assert add(5, 0) == 5

    def test_subtract(self):
        assert subtract(10, 4) == 6

    def test_multiply(self):
        assert multiply(3, 4) == 12

    def test_divide_normal(self):
        assert divide(10, 2) == 5.0

    def test_divide_by_zero(self):
        with pytest.raises(ValueError):
            divide(10, 0)

class TestGreet:
    def test_greet_valid(self):
        result = greet("Asim")
        assert "Asim" in result
        assert "Hello" in result

    def test_greet_empty(self):
        with pytest.raises(ValueError):
            greet("")

class TestHealthCheck:
    def test_health_check_returns_dict(self):
        result = health_check()
        assert isinstance(result, dict)

    def test_health_check_status(self):
        result = health_check()
        assert result["status"] == "healthy"

    def test_health_check_has_version(self):
        result = health_check()
        assert "version" in result
