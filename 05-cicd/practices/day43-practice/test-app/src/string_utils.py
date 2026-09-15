"""
string_utils.py
String manipulation utilities
Author: Asim Raza - Day 43
"""


def reverse_string(s: str) -> str:
    """Reverse a string"""
    if not isinstance(s, str):
        raise TypeError("Input must be a string")
    return s[::-1]


def count_vowels(s: str) -> int:
    """Count vowels in a string"""
    if not isinstance(s, str):
        raise TypeError("Input must be a string")
    return sum(1 for c in s.lower()
               if c in 'aeiou')


def is_palindrome(s: str) -> bool:
    """Check if string is a palindrome"""
    if not isinstance(s, str):
        raise TypeError("Input must be a string")
    cleaned = re.sub(r'[^a-zA-Z0-9]', '', s.lower()) \
        if __import__('re').search(r'\W', s) else s.lower()
    return cleaned == cleaned[::-1]


def word_count(text: str) -> dict:
    """Count word frequencies"""
    if not isinstance(text, str):
        raise TypeError("Input must be a string")
    words = text.lower().split()
    counts = {}
    for word in words:
        counts[word] = counts.get(word, 0) + 1
    return counts


def truncate(s: str, length: int,
             suffix: str = '...') -> str:
    """Truncate string to length"""
    if not isinstance(s, str):
        raise TypeError("Input must be a string")
    if len(s) <= length:
        return s
    return s[:length - len(suffix)] + suffix
