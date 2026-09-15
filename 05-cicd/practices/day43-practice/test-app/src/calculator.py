"""
calculator.py
Math operations with error handling
Author: Asim Raza - Day 43
"""

class Calculator:
    """Simple calculator with history"""

    def __init__(self):
        self.history = []

    def add(self, a: float, b: float) -> float:
        result = a + b
        self.history.append(f"{a} + {b} = {result}")
        return result

    def subtract(self, a: float, b: float) -> float:
        result = a - b
        self.history.append(f"{a} - {b} = {result}")
        return result

    def multiply(self, a: float, b: float) -> float:
        result = a * b
        self.history.append(f"{a} * {b} = {result}")
        return result

    def divide(self, a: float, b: float) -> float:
        if b == 0:
            raise ValueError("Cannot divide by zero")
        result = a / b
        self.history.append(f"{a} / {b} = {result}")
        return result

    def power(self, base: float, exp: float) -> float:
        result = base ** exp
        self.history.append(f"{base} ^ {exp} = {result}")
        return result

    def get_history(self) -> list:
        return self.history.copy()

    def clear_history(self) -> None:
        self.history.clear()

    def get_last_result(self) -> float:
        if not self.history:
            raise ValueError("No calculations performed")
        last = self.history[-1]
        return float(last.split("= ")[1])
