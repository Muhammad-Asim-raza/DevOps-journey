"""
test_calculator.py
Comprehensive tests for Calculator class
Author: Asim Raza - Day 43
"""
import pytest
import sys
import os
sys.path.insert(0, os.path.join(
    os.path.dirname(__file__), '..'))

from src.calculator import Calculator


class TestCalculatorBasic:
    """Basic arithmetic operations"""

    def setup_method(self):
        """Fresh calculator for each test"""
        self.calc = Calculator()

    def test_add_positive_numbers(self):
        assert self.calc.add(2, 3) == 5

    def test_add_negative_numbers(self):
        assert self.calc.add(-1, -2) == -3

    def test_add_zero(self):
        assert self.calc.add(5, 0) == 5

    def test_add_floats(self):
        assert abs(self.calc.add(1.5, 2.5) - 4.0) < 0.001

    def test_subtract_positive(self):
        assert self.calc.subtract(10, 4) == 6

    def test_subtract_negative_result(self):
        assert self.calc.subtract(3, 10) == -7

    def test_multiply_positive(self):
        assert self.calc.multiply(3, 4) == 12

    def test_multiply_by_zero(self):
        assert self.calc.multiply(5, 0) == 0

    def test_multiply_negative(self):
        assert self.calc.multiply(-3, 4) == -12

    def test_divide_normal(self):
        assert self.calc.divide(10, 2) == 5.0

    def test_divide_by_zero_raises(self):
        with pytest.raises(ValueError) as exc_info:
            self.calc.divide(10, 0)
        assert "zero" in str(exc_info.value).lower()

    def test_divide_float_result(self):
        result = self.calc.divide(7, 2)
        assert result == 3.5

    def test_power_positive(self):
        assert self.calc.power(2, 10) == 1024

    def test_power_zero_exponent(self):
        assert self.calc.power(5, 0) == 1

    def test_power_one_base(self):
        assert self.calc.power(1, 100) == 1


class TestCalculatorHistory:
    """History tracking functionality"""

    def setup_method(self):
        self.calc = Calculator()

    def test_history_starts_empty(self):
        assert self.calc.get_history() == []

    def test_history_records_operations(self):
        self.calc.add(1, 2)
        self.calc.multiply(3, 4)
        history = self.calc.get_history()
        assert len(history) == 2

    def test_history_format(self):
        self.calc.add(5, 3)
        history = self.calc.get_history()
        assert "5" in history[0]
        assert "3" in history[0]
        assert "8" in history[0]

    def test_clear_history(self):
        self.calc.add(1, 2)
        self.calc.add(3, 4)
        self.calc.clear_history()
        assert self.calc.get_history() == []

    def test_get_last_result(self):
        self.calc.add(7, 3)
        assert self.calc.get_last_result() == 10.0

    def test_get_last_result_no_history(self):
        with pytest.raises(ValueError):
            self.calc.get_last_result()

    def test_history_returns_copy(self):
        self.calc.add(1, 2)
        history = self.calc.get_history()
        history.append("fake entry")
        # Original should not be affected
        assert len(self.calc.get_history()) == 1


class TestCalculatorEdgeCases:
    """Edge cases and boundary conditions"""

    def setup_method(self):
        self.calc = Calculator()

    def test_large_numbers(self):
        result = self.calc.multiply(1_000_000, 1_000_000)
        assert result == 1_000_000_000_000

    def test_very_small_floats(self):
        result = self.calc.add(0.1, 0.2)
        assert abs(result - 0.3) < 0.001

    def test_chain_operations(self):
        result1 = self.calc.add(10, 5)
        result2 = self.calc.multiply(result1, 2)
        assert result2 == 30
