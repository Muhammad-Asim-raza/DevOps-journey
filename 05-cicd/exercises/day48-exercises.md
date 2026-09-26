# Day 48 Exercises — GitLab CI/CD
**Date:** Aug 5 2026
**Status:** ✅ Completed

---

## Exercise 1: GitLab CI Anatomy ✅
- [x] Complete .gitlab-ci.yml with all keywords
- [x] stages, variables, before_script
- [x] Jobs with all options documented
- [x] artifacts, rules, environment, when

### Proof: practices/day48-practice/exercise1-proof.txt
### File: gitlab-configs/01-anatomy.gitlab-ci.yml

### Stage Execution
Same stage → jobs run PARALLEL
Different stages → run SEQUENTIAL
This is opposite to GitHub Actions
(where jobs run parallel by default)

---

## Exercise 2: Variables Reference ✅
- [x] All predefined CI_* variables shown
- [x] Custom variables (pipeline, job-level)
- [x] Variable masking and protection
- [x] File-type variables (kubeconfig)

### Proof: practices/day48-practice/exercise2-proof.txt
### File: gitlab-configs/02-variables.gitlab-ci.yml

### Auto-provided Docker Auth
CI_REGISTRY = registry.gitlab.com
CI_REGISTRY_USER = auto
CI_REGISTRY_PASSWORD = auto (job token)
NO secrets to configure for GitLab Registry!

---

## Exercise 3: Cache and Artifacts ✅
- [x] pip cache with file-based key
- [x] cache policy (pull-push vs pull)
- [x] artifacts.paths for file passing
- [x] artifacts.reports.junit (MR integration)
- [x] artifacts.expire_in

### Proof: practices/day48-practice/exercise3-proof.txt
### File: gitlab-configs/03-cache-artifacts.gitlab-ci.yml

### Cache Key Strategy
key.files: [requirements.txt]
→ Hash of requirements.txt as cache key
→ Changes when requirements change
→ Same as hashFiles() in GitHub Actions

---

## Exercise 4: Rules and Environments ✅
- [x] rules: with if/changes/when
- [x] Static environments (staging/production)
- [x] Dynamic environments (review apps)
- [x] on_stop for environment cleanup
- [x] auto_stop_in for auto-cleanup
- [x] Protected environments with approval

### Proof: practices/day48-practice/exercise4-proof.txt
### File: gitlab-configs/04-rules-environments.gitlab-ci.yml

### Review Apps Pattern
environment:
  name: review/$CI_COMMIT_REF_SLUG
  url: https://$CI_COMMIT_REF_SLUG.review.example.com
  auto_stop_in: 3 days

One URL per feature branch
Auto-cleaned after 3 days
Reviewers can test on live environment

---

## Exercise 5: Complete Pipeline ✅
- [x] 6 stages with emoji labels
- [x] YAML anchors (&pip-cache, &docker-login)
- [x] needs: for parallel optimization
- [x] rules: per job
- [x] All artifacts and reports

### File: gitlab-configs/05-complete-pipeline.gitlab-ci.yml

---

## GitLab CI Unique Features

### Built-in Container Registry
docker login -u $CI_REGISTRY_USER \
    -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
No external account, no secrets setup!

### MR Test Integration
artifacts:
  reports:
    junit: junit-report.xml
Shows pass/fail counts directly in MR!

### Coverage in MR
coverage: '/TOTAL.*\s+(\d+%)/'
Shows coverage % in MR sidebar!

### Review Apps (per-MR environments)
environment:
  name: review/$CI_COMMIT_REF_SLUG

---

## Summary
All 5 exercises completed Aug 5 2026

Files created:
- 01-anatomy.gitlab-ci.yml
- 02-variables.gitlab-ci.yml
- 03-cache-artifacts.gitlab-ci.yml
- 04-rules-environments.gitlab-ci.yml
- 05-complete-pipeline.gitlab-ci.yml

Scripts: gitlab-ci-reference.sh

Key concepts mastered:
- GitLab CI vs GitHub Actions vs Jenkins
- Stage = parallel jobs, sequential stages
- All job keywords (script, rules, when, needs)
- Predefined CI_* variables (30+)
- Cache with file-based keys
- Artifacts with JUnit/coverage reports
- rules: vs only/except
- Environments and deployments
- Review apps (dynamic environments)
- Built-in container registry
- YAML anchors for DRY configs
- needs: for pipeline optimization
