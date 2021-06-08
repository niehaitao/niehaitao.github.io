#!/usr/bin/groovy
GString POD_LABEL = "your-job-${UUID.randomUUID().toString()}"

pipeline {
    agent { kubernetes { label POD_LABEL } }
    parameters {
        choice(name: 'EXPECT_STATUS', choices: ['SUCCESS', 'UNSTABLE', 'FAILURE', 'ABORTED', 'CYCLE'])
        choice(name: 'EXPECT_SLEEP',  choices: ['1', '10', '20', '30', '60', '120', '300'])
    }
    
    environment { MY_VAR = 'foo' }

    stages {
        stage('Hello') {
            steps {
                script { MY_VAR = 'bar' }
                sh "echo Hello ${MY_VAR}: ${params.EXPECT_STATUS}! | tee /tmp/data" 
            }
        }
        stage('Sleep'){
            steps { 
                sh "sleep ${params.EXPECT_SLEEP}" 
            }
        }
        stage('Wake Up'){
            steps { 
                sh "echo Hello ${MY_VAR}: ${params.EXPECT_STATUS}! | cat /tmp/data" 
            }
        }
        stage('Status'){
            steps { 
                script { currentBuild.result = params.EXPECT_STATUS } 
            }
        }
    }
}