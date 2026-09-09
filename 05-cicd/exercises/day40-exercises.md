# Day 40 Exercises — GitHub Actions Fundamentals
**Date:** Jul 28 2026
**Status:** ✅ Completed

---

## Exercise 1: Five Workflows Created ✅
- [x] 01-anatomy.yml (complete workflow anatomy)
- [x] 02-triggers.yml (all trigger types)
- [x] 03-jobs-steps.yml (jobs and steps deep dive)
- [x] 04-expressions.yml (contexts and expressions)
- [x] 05-real-ci-pipeline.yml (real CI pipeline)

### Proof
See: practices/day40-practice/exercise1-proof.txt
See: practices/day40-practice/workflow-demos/

### Workflows File Location
.github/workflows/*.yml

### What Triggers Each
01-anatomy: push to main + 05-cicd/ path + manual
02-triggers: push/PR/schedule/manual/release
03-jobs-steps: push to main + manual
04-expressions: push to main + manual
05-real-ci-pipeline: push/PR to main + manual

---

## Exercise 2: Concepts Mastered ✅
- [x] All trigger types (push/PR/schedule/dispatch)
- [x] Jobs parallel vs sequential (needs:)
- [x] Step types (uses, run, env, id)
- [x] Matrix strategy
- [x] Artifacts upload and download
- [x] Context variables (github/runner/env)
- [x] Expressions and functions
- [x] GITHUB_OUTPUT and GITHUB_ENV
- [x] Conditional execution (if:)
- [x] GITHUB_STEP_SUMMARY

### Proof
See: practices/day40-practice/exercise2-proof.txt

---

## Key Concepts Reference

### Trigger Priority
push: most common, every commit
pull_request: quality gate before merge
workflow_dispatch: manual when needed
schedule: maintenance/nightly builds

### Job Execution
No needs: → parallel (default)
needs: [a,b] → sequential (after a AND b pass)
if: always() → run even if previous failed

### Step Output Pattern
- name: Set value
  id: my-step
  run: echo "key=value" >> $GITHUB_OUTPUT

- name: Use value
  run: echo ${{ steps.my-step.outputs.key }}

### Environment Variable Pattern
- name: Set env var
  run: echo "MY_VAR=hello" >> $GITHUB_ENV

- name: Use env var
  run: echo $MY_VAR  # or ${{ env.MY_VAR }}

### Concurrency Pattern
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

Prevents: old run finishing AFTER new one starts

---

## Summary
All exercises completed on Jul 28 2026

Scripts written:
- github-actions-reference.sh

Workflows written (5 total):
- 01-anatomy.yml
- 02-triggers.yml
- 03-jobs-steps.yml
- 04-expressions.yml
- 05-real-ci-pipeline.yml

Proof files:
- exercise1-proof.txt
- exercise2-proof.txt
- script-output-actions.txt

Key concepts mastered:
- Workflow YAML anatomy
- All trigger types
- Job parallelism and sequencing
- Step types and options
- Matrix strategy
- Artifacts (upload/download)
- Context variables
- Expressions and conditionals
- Special environment files
- Real CI pipeline structure
