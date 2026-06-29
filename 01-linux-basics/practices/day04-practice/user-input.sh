#!/bin/bash
# ================================================
# user-input.sh — Getting Input from User
# ================================================

# Ask user for their name
echo "What is your name?"
read NAME
# read = wait for user to type something
#        store it in variable NAME

echo "Hello $NAME! Welcome to DevOps!"

# Ask for server name
echo ""
echo "Which server do you want to check?"
read SERVER_NAME

echo "Checking server: $SERVER_NAME"
echo "Status: Running ✅"

# Read with a prompt on same line
echo ""
read -p "Enter your age: " AGE
# -p = show prompt on same line as input

echo "$NAME is $AGE years old"
