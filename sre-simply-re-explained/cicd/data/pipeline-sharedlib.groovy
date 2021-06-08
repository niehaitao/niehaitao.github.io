@Library('pop-cloud-jenkins-shared-libs') _

GString POD_LABEL = "your-jenkinsfile-${UUID.randomUUID().toString()}"
pipeline {
    agent { kubernetes { label POD_LABEL } }
    stages {
        stage('Hello') {
            steps {
                script {
                    def reply=foo.sayHello what: 'World'
                    echo reply
                }
            }
        }
    }
}