# Day 41 Exercises — Advanced GitHub Actions Workflows
**Date:** Jul 29 2026
**Status:** ✅ Completed

---

## Exercise 1: Reusable Workflows ✅
- [x] Created called workflow (workflow_call)
- [x] Defined inputs, secrets, and outputs
- [x] Created caller workflow
- [x] Passed inputs and secrets to called
- [x] Read outputs from called workflow

### Proof
See: practices/day41-practice/exercise1-proof.txt
See: .github/workflows/06-reusable-called.yml
See: .github/workflows/07-reusable-caller.yml

### Pattern
Called (06): on: workflow_call: inputs/secrets/outputs
Caller (07): uses: ./.github/workflows/06...
             with: (inputs)
             secrets: (secrets)

---

## Exercise 2: Composite Actions ✅
- [x] Created action.yml with composite runs
- [x] Defined inputs and outputs
- [x] Used composite action in workflow
- [x] Compared with/without composite

### Proof
See: practices/day41-practice/exercise2-proof.txt
See: .github/actions/setup-python-project/action.yml
See: .github/workflows/08-composite-action.yml

### Key Difference
Reusable workflow = separate jobs on runners
Composite action  = steps run inline (same runner)

---

## Exercise 3: Deployment Environments ✅
- [x] Created deployment workflow
- [x] Used environment: name: staging
- [x] Used environment: name: production
- [x] Set environment URL
- [x] Implemented build → staging → production flow

### Proof
See: practices/day41-practice/exercise3-proof.txt
See: .github/workflows/09-environments.yml

### Setup in GitHub
Settings → Environments → New environment
- staging: no protection
- production: required reviewers + wait timer

---

## Exercise 4: Advanced Patterns ✅
- [x] Dynamic matrix generation
- [x] Fan-out (one → many parallel)
- [x] Fan-in (many → one collector)
- [x] Skip CI with commit message
- [x] Debug mode
- [x] GITHUB_STEP_SUMMARY

### Proof
See: practices/day41-practice/exercise4-proof.txt
See: .github/workflows/10-advanced-patterns.yml

### Dynamic Matrix
generate-matrix outputs JSON → test-dynamic reads with fromJSON()
Different matrix for main vs feature branches

---

## Exercise 5: Complete Advanced Pipeline ✅
- [x] Concurrency control
- [x] Validate → Lint/Test/Security (parallel) → Build → Deploy
- [x] Job outputs passed between stages
- [x] environment: production with URL
- [x] Final report with GITHUB_STEP_SUMMARY
- [x] Notification on failure

### Proof
See: .github/workflows/11-complete-advanced-pipeline.yml

---

## Advanced Concepts Summary

### Reusable Workflow Pattern
Define: on: workflow_call: with inputs/outputs
Use: uses: ./path/workflow.yml with: inputs
Read: needs.called-job.outputs.key

### Composite Action Pattern
Create: .github/actions/name/action.yml
runs: using: composite, steps: [...]
Use: uses: ./.github/actions/name

### Fan-out / Fan-in
Fan-out: matrix or multiple parallel jobs
Fan-in: needs: [a, b, c] + if: always()

### Skip CI
[skip ci] in commit message
Check: contains(github.event.head_commit.message, '[skip ci]')

---

## Summary
All 5 exercises completed on Jul 29 2026

Scripts: advanced-actions-reference.sh
Workflows: 06 07 08 09 10 11 (6 workflows)
Actions: setup-python-project (composite)

Key concepts mastered:
- Reusable workflows (DRY CI/CD)
- Composite actions (reusable steps)
- Deployment environments (protection rules)
- Dynamic matrix generation
- Fan-out / Fan-in patterns
- Skip CI in commit messages
- Concurrency control
- GITHUB_STEP_SUMMARY

