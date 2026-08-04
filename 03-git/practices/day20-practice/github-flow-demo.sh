#!/bin/bash
# ================================================
# github-flow-demo.sh
# Demonstrates GitHub Flow branching strategy
# Author: Asim Raza
# Day 20 of DevOps Journey
# ================================================

echo "============================================"
echo "   GITHUB FLOW DEMONSTRATION"
echo "   Author: Asim Raza - Day 20"
echo "============================================"

# Must be run inside branch-practice repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Run this from inside branch-practice directory"
    exit 1
fi

echo ""
echo "[ GITHUB FLOW RULES ]"
echo "  1. main is ALWAYS deployable"
echo "  2. Create branch for ANY change"
echo "  3. Open Pull Request for discussion"
echo "  4. Tests must pass before merge"
echo "  5. Merge to main"
echo "  6. Deploy immediately after merge"

echo ""
echo "[ SIMULATING GITHUB FLOW ]"

# Step 1: Start from main
echo ""
echo "Step 1: Ensure we are on main"
git switch main 2>/dev/null
echo "  Current branch: $(git branch --show-current)"

# Step 2: Create feature branch
echo ""
echo "Step 2: Create feature branch"
git switch -c feature/api-endpoints 2>/dev/null || \
    git switch feature/api-endpoints
echo "  Created: feature/api-endpoints"
echo "  Current: $(git branch --show-current)"

# Step 3: Make changes
echo ""
echo "Step 3: Make changes (simulate development)"
cat > api.py << 'PYEOF'
# API Endpoints Module
# Created following GitHub Flow

def get_users():
    """GET /users - return all users"""
    return [
        {"id": 1, "name": "Asim Raza"},
        {"id": 2, "name": "DevOps Engineer"}
    ]

def create_user(name, email):
    """POST /users - create new user"""
    return {"id": 3, "name": name, "email": email}

def get_health():
    """GET /health - health check"""
    return {"status": "healthy", "version": "2.0.0"}
PYEOF

git add api.py
git commit -m "Add API endpoints for users and health check"
echo "  Committed: Add API endpoints"

# Step 4: Simulate more work
cat >> api.py << 'PYEOF2'

def delete_user(user_id):
    """DELETE /users/:id - delete user"""
    return {"deleted": True, "id": user_id}
PYEOF2

git add api.py
git commit -m "Add delete user endpoint"
echo "  Committed: Add delete user endpoint"

# Step 5: Show what would happen in PR
echo ""
echo "Step 4: (In real life: Open Pull Request on GitHub)"
echo "  PR Title: Add API endpoints for users"
echo "  PR Description: Adds GET/POST/DELETE for /users"
echo "  Reviewer: Team lead"
echo "  Checks: CI tests pass ✅"
echo "  Status: Approved ✅"

# Step 6: Merge to main
echo ""
echo "Step 5: Merge approved PR to main"
git switch main
git merge feature/api-endpoints \
    -m "Merge feature/api-endpoints - Add user API"
echo "  Merged to main ✅"

# Step 7: Delete feature branch
git branch -d feature/api-endpoints
echo "  Deleted feature branch ✅"

# Step 8: Show final state
echo ""
echo "Step 6: Deploy to production"
echo "  (CI/CD pipeline triggered by push to main)"
echo "  Building Docker image..."
echo "  Running tests..."
echo "  Deploying to production..."
echo "  ✅ Deployed successfully!"

echo ""
echo "[ FINAL REPOSITORY STATE ]"
git log --oneline --graph --all -8
echo ""
echo "Files in project:"
ls

echo ""
echo "============================================"
echo "   GITHUB FLOW DEMO COMPLETE"
echo "============================================"
