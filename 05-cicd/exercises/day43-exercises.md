# Day 43 Exercises — Build & Test Automation
**Date:** Jul 31 2026
**Status:** ✅ Completed

---

## Exercise 1: Test App and Local Tests ✅
- [x] Created src/ with calculator, validator, string_utils
- [x] Created comprehensive test suite (40+ tests)
- [x] Ran tests locally with pytest
- [x] Verified coverage > 80%
- [x] Configured pytest.ini

### Proof: practices/day43-practice/exercise1-proof.txt
### App: practices/day43-practice/test-app/

### Test Counts
test_calculator.py: 17 tests
test_validator.py: 24 tests
Total: 41+ tests

---

## Exercise 2: Complete Test Workflow ✅
- [x] Lint gate (flake8, isort)
- [x] Unit tests with matrix (3.10, 3.11)
- [x] Coverage report (xml + html)
- [x] Security scan (bandit, safety)
- [x] Build artifact after tests pass
- [x] Summary report

### Proof: practices/day43-practice/exercise2-proof.txt
### Workflow: .github/workflows/16-test-automation.yml

### Key Flags
--cov-fail-under=80    = fail if < 80% coverage
--junit-xml=results    = JUnit format for CI
-n auto                = parallel execution

---

## Exercise 3: Caching Strategy ✅
- [x] Python cache with setup-python cache: pip
- [x] Manual cache with actions/cache@v3
- [x] Docker layer cache (type=gha)
- [x] Cache key strategies (hashFiles)
- [x] restore-keys fallback chains

### Proof: practices/day43-practice/exercise3-proof.txt  
### Workflow: .github/workflows/17-caching-strategy.yml

### Cache Key Pattern
key: pip-${{ runner.os }}-${{ hashFiles('requirements.txt') }}
restore-keys: pip-${{ runner.os }}-

---

## Exercise 4: Quality Gates ✅
- [x] Gate 1: Lint (0 errors)
- [x] Gate 2: Coverage >= 80%
- [x] Gate 3: Test count >= 10
- [x] Gate 4: Complexity warning
- [x] Pipeline fails if gates not met
- [x] GITHUB_STEP_SUMMARY table

### Proof: practices/day43-practice/exercise4-proof.txt
### Workflow: .github/workflows/18-quality-gates.yml

### Quality Gate Implementation
After each check: output pass/fail flag
Final step: evaluate all flags
If any critical gate fails: exit 1
Pipeline stops, PR cannot merge

---

## Exercise 5: Parallel Testing ✅
- [x] pytest-xdist (-n auto)
- [x] Matrix parallel jobs
- [x] Fan-in collector job
- [x] Artifact aggregation

### Workflow: .github/workflows/19-parallel-testing.yml

---

## Key Patterns

### Pytest Coverage Gate
python -m pytest tests/ \
  --cov=src \
  --cov-fail-under=80 \
  --junit-xml=results.xml

### Cache Pattern
- uses: actions/cache@v3
  with:
    path: ~/.cache/pip
    key: pip-${{ runner.os }}-${{ hashFiles('requirements.txt') }}
    restore-keys: pip-${{ runner.os }}-

### Quality Gate Pattern
- name: Check coverage
  id: cov-gate
  run: |
    # run tests and get coverage
    echo "coverage-passed=true" >> $GITHUB_OUTPUT

- name: Enforce gates
  run: |
    if [ "${{ steps.cov-gate.outputs.coverage-passed }}" != "true" ]; then
      exit 1  # fail the pipeline
    fi

---

## Summary
All 5 exercises completed on Jul 31 2026

Scripts: test-automation-reference.sh
Workflows: 16 17 18 19 (4 workflows)
App: test-app/ with 41+ tests

Key concepts mastered:
- Test pyramid (unit/integration/e2e)
- pytest with all important flags
- Coverage reporting and gates
- JUnit XML for CI systems
- Dependency caching strategies
- Quality gates with auto pass/fail
- Parallel testing (xdist + matrix)
- GITHUB_STEP_SUMMARY reports
