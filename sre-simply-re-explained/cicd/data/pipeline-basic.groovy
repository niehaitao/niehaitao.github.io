#!/usr/bin/groovy
GString POD_LABEL = "your-job-${UUID.randomUUID().toString()}"
pipeline {
    agent { kubernetes { label POD_LABEL } }
    stages {
        stage('Hello') {
            steps {
                script {
                    echo "Hello World!"
                }
            }
        }
    }
}
