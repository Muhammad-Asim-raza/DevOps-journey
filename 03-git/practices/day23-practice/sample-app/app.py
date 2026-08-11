# Sample App for GitHub Actions Demo
# Author: Asim Raza - Day 23

VERSION = "1.0.0"

def add(a, b):
    """Add two numbers"""
    return a + b

def subtract(a, b):
    """Subtract b from a"""
    return a - b

def multiply(a, b):
    """Multiply two numbers"""
    return a * b

def divide(a, b):
    """Divide a by b"""
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b

def greet(name):
    """Return greeting"""
    if not name:
        raise ValueError("Name cannot be empty")
    return f"Hello, {name}! Welcome to DevOps."

def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "version": VERSION,
        "service": "devops-app"
    }

if __name__ == "__main__":
    print(health_check())
    print(greet("Asim"))
