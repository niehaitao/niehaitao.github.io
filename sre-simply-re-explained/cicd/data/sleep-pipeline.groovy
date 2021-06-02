#!/usr/bin/groovy
GString POD_LABEL = "your-job-${UUID.randomUUID().toString()}"

pipeline {
    agent { kubernetes { label POD_LABEL } }
    parameters {
        choice(name: 'EXPECT_STATUS', choices: ['SUCCESS', 'UNSTABLE', 'FAILURE', 'ABORTED', 'CYCLE'])
        choice(name: 'EXPECT_SLEEP',  choices: ['1', '10', '20', '30', '60', '120', '300'])
    }
    stages {
        stage('Hello') {
            steps { script { echo "Hello World ${params.EXPECT_STATUS} !" } }
        }
        stage('Sleep'){
            steps { sh "sleep ${params.EXPECT_SLEEP}" }
        }
        stage('Status'){
            steps { script { currentBuild.result = params.EXPECT_STATUS } }
        }
    }
}