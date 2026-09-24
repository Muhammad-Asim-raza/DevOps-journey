# Day 47 Exercises — Jenkins Pipelines (Jenkinsfile)
**Date:** Aug 4 2026
**Status:** ✅ Completed

---

## Exercise 1: Complete Declarative Jenkinsfile ✅
- [x] Full pipeline with all sections documented
- [x] agent, options, parameters, environment
- [x] stages with when{} conditions
- [x] parallel stages
- [x] script{} blocks for Groovy
- [x] input{} for manual approval
- [x] post{} all conditions

### Proof: practices/day47-practice/exercise1-proof.txt
### File: jenkinsfiles/Jenkinsfile.complete

### Key Sections
pipeline { }        = required wrapper
agent               = where to run
options             = timeouts, cleanup, timestamps
parameters          = human inputs
environment         = variables for all stages
stages { stage{} }  = actual work
post { }            = after everything

---

## Exercise 2: Advanced Patterns ✅
- [x] retry() for flaky operations
- [x] stash/unstash across agents
- [x] archiveArtifacts
- [x] All Jenkins built-in variables
- [x] script{} Groovy blocks
- [x] All when{} condition types
- [x] try/catch error handling

### Proof: practices/day47-practice/exercise2-proof.txt
### File: jenkinsfiles/Jenkinsfile.patterns

### Most Important Patterns
stash/unstash: share files between agents
archiveArtifacts: permanent storage
withCredentials: inject secrets safely
retry(N): handle transient failures
script{}: Groovy logic in declarative

---

## Exercise 3: Multi-Branch Pipeline ✅
- [x] Different behavior per branch
- [x] PR detection (CHANGE_ID)
- [x] Main branch auto-deploy
- [x] Feature branch: test only
- [x] Input step for production approval

### Proof: practices/day47-practice/exercise3-proof.txt
### File: jenkinsfiles/Jenkinsfile.multibranch

---

## Exercise 4: Shared Libraries ✅
- [x] @Library annotation
- [x] Library repo structure
- [x] vars/ global functions
- [x] Why shared libraries matter

### Proof: practices/day47-practice/exercise4-proof.txt
### File: jenkinsfiles/Jenkinsfile.shared-library

---

## Key Syntax Reference

### Credentials (3 ways)
withCredentials([string(credentialsId:'id', variable:'VAR')]) {}
withCredentials([usernamePassword(credentialsId:'id', usernameVariable:'U', passwordVariable:'P')]) {}
sshagent(['key-id']) { sh 'ssh ...' }

### When Conditions
when { branch 'main' }
when { not { changeRequest() } }
when { allOf { branch 'main'; not { changeRequest() } } }
when { expression { env.BUILD_NUMBER.toInteger() > 1 } }

### Post Conditions
post {
  always  { cleanWs() }
  success { slackSend color:'good' }
  failure { emailext ... }
  changed { echo "Status changed!" }
}

---

## Declarative vs Scripted

Declarative (use this):
pipeline { stages { stage { steps { } } } }

Scripted (avoid unless needed):
node { stage('name') { sh '...' } }

---

## Summary
All 4 exercises completed Aug 4 2026

Jenkinsfiles created (5):
- Jenkinsfile.complete (full reference)
- Jenkinsfile.production (real pipeline)
- Jenkinsfile.patterns (advanced patterns)
- Jenkinsfile.multibranch (multi-branch)
- Jenkinsfile.shared-library (shared libs)

Key concepts mastered:
- Declarative vs Scripted pipeline
- All pipeline sections
- when{} conditions (6 types)
- parallel stages
- post{} conditions (6 types)
- script{} Groovy blocks
- stash/unstash pattern
- withCredentials patterns
- Multi-branch pipeline behavior
- Shared libraries concept
- Jenkins built-in variables
