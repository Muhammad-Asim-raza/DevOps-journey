"""
validator.py
Input validation utilities
Author: Asim Raza - Day 43
"""
import re
from typing import Optional


def validate_email(email: str) -> bool:
    """Validate email address format"""
    if not isinstance(email, str):
        return False
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email))


def validate_ip(ip: str) -> bool:
    """Validate IPv4 address"""
    if not isinstance(ip, str):
        return False
    parts = ip.split('.')
    if len(parts) != 4:
        return False
    try:
        return all(0 <= int(p) <= 255 for p in parts)
    except ValueError:
        return False


def validate_port(port) -> bool:
    """Validate network port number"""
    try:
        p = int(port)
        return 1 <= p <= 65535
    except (TypeError, ValueError):
        return False


def sanitize_string(text: str,
                    max_length: int = 255) -> str:
    """Remove dangerous characters from string"""
    if not isinstance(text, str):
        raise TypeError("Input must be a string")
    # Remove null bytes and control characters
    cleaned = re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f]', '', text)
    # Trim to max length
    return cleaned[:max_length]


def validate_url(url: str) -> bool:
    """Validate URL format"""
    if not isinstance(url, str):
        return False
    pattern = r'^https?://[^\s/$.?#].[^\s]*$'
    return bool(re.match(pattern, url))
