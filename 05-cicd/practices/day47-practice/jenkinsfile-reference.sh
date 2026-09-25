#!/bin/bash
# ================================================
# jenkinsfile-reference.sh
# Jenkinsfile Complete Reference
# Author: Asim Raza - Day 47
# ================================================

echo "============================================"
echo "   JENKINSFILE REFERENCE"
echo "   Author: Asim Raza - Day 47"
echo "============================================"

echo ""
echo "[ PIPELINE SKELETON ]"
cat << 'EOF'
pipeline {
    agent any
    options { timestamps(); buildDiscarder(logRotator(numToKeepStr: '20')) }
    environment { APP_NAME = 'myapp' }
    parameters { string(name: 'ENV', defaultValue: 'staging') }
    stages {
        stage('Build') {
            steps { sh 'make build' }
        }
    }
    post {
        always  { cleanWs() }
        success { echo "Passed!" }
        failure { echo "Failed!" }
    }
}
EOF

echo ""
echo "[ AGENT OPTIONS ]"
echo "  agent any                        = any available agent"
echo "  agent none                       = set per-stage"
echo "  agent { label 'linux' }          = labeled agent"
echo "  agent { docker { image '...' } } = Docker container"
echo "  agent { kubernetes { yaml '...' } } = K8s pod"

echo ""
echo "[ COMMON STEPS ]"
echo "  sh 'command'                 = run shell command"
echo "  sh '''multiline'''           = multi-line shell"
echo "  echo 'message'              = print to log"
echo "  dir('path') { steps }       = change directory"
echo "  checkout scm                 = clone from job SCM"
echo "  withCredentials([...]) {}   = inject credentials"
echo "  script { groovy code }      = Groovy in declarative"
echo "  stash name: 'files'         = save files between agents"
echo "  unstash 'files'             = restore stashed files"
echo "  archiveArtifacts 'files/**' = save to Jenkins"
echo "  junit 'results.xml'         = publish test results"
echo "  retry(3) { steps }          = retry on failure"
echo "  timeout(time:5, unit:'MINUTES') { steps }"
echo "  input message: 'Approve?'   = pause for human"
echo "  cleanWs()                   = delete workspace"

echo ""
echo "[ CREDENTIALS IN PIPELINE ]"
echo "  // Username + Password:"
echo "  withCredentials([usernamePassword("
echo "    credentialsId: 'my-creds',"
echo "    usernameVariable: 'USER',"
echo "    passwordVariable: 'PASS')]) {"
echo "    sh 'login --user \$USER --pass \$PASS'"
echo "  }"
echo ""
echo "  // Secret text:"
echo "  withCredentials([string("
echo "    credentialsId: 'api-key',"
echo "    variable: 'API_KEY')]) {"
echo "    sh 'curl -H \"Auth: \$API_KEY\" ...'"
echo "  }"
echo ""
echo "  // SSH key:"
echo "  sshagent(['deploy-key']) {"
echo "    sh 'ssh user@server ./deploy.sh'"
echo "  }"

echo ""
echo "[ WHEN CONDITIONS ]"
echo "  when { branch 'main' }"
echo "  when { tag 'v*' }"
echo "  when { changeRequest() }            = is PR"
echo "  when { not { changeRequest() } }    = not PR"
echo "  when { expression { condition } }"
echo "  when { environment name:'K', value:'V' }"
echo "  when { allOf { cond1; cond2 } }     = AND"
echo "  when { anyOf { cond1; cond2 } }     = OR"

echo ""
echo "[ POST CONDITIONS ]"
echo "  always    = runs always (cleanup)"
echo "  success   = only on success"
echo "  failure   = only on failure"
echo "  unstable  = test failures"
echo "  aborted   = cancelled by human"
echo "  changed   = result changed from last build"

echo ""
echo "[ JENKINS BUILT-IN VARIABLES ]"
echo "  BUILD_NUMBER  = current build number"
echo "  BUILD_URL     = URL to this build"
echo "  JOB_NAME      = full job name"
echo "  WORKSPACE     = build workspace path"
echo "  GIT_BRANCH    = current git branch"
echo "  GIT_COMMIT    = full commit SHA"
echo "  BRANCH_NAME   = branch (multibranch)"
echo "  CHANGE_ID     = PR number (if PR build)"

echo ""
echo "[ JENKINSFILES CREATED TODAY ]"
ls ~/DevOps-journey/05-cicd/practices/day47-practice/jenkinsfiles/

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
