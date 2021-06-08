#!/usr/bin/groovy
GString POD_LABEL = "your-job-${UUID.randomUUID().toString()}"
pipeline {
  agent {
    kubernetes {
      label POD_LABEL
      yaml """
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            run: my-pod
          name: my-pod
        spec:
          containers:
            - name: jnlp
              image: jenkins/inbound-agent:4.3-4-alpine
              imagePullPolicy: IfNotPresent
              args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
              env:
                - name: foo
                  value: abc-jnlp
            - name: container-nginx
              image: nginx:1.15.9
              imagePullPolicy: IfNotPresent
              env:
                - name: foo
                  value: abc-nginx
            - name: container-redis
              image: redis:alpine
              imagePullPolicy: IfNotPresent
              env:
                - name: foo
                  value: abc-redis
              volumeMounts:
              - name: redis-storage
                mountPath: /var/redis-storage
          volumes:
          - name: redis-storage
            emptyDir: {}
      """
    }
  }

  stages {
    stage('none') {
      steps {
        sh """ 
          echo foo $foo
          ls -l /var
        """
      }
    }
    
    stage('jnlp') {
      steps {
        container('jnlp') {        
          sh """ 
            echo foo $foo
            echo Working in $POD_CONTAINER
            ls -l /var
          """
        }
      }
    }

    stage('nginx') {
      steps {
        container('container-nginx') {
          sh """ 
            echo foo $foo
            echo Working in $POD_CONTAINER
            ls -l /var
          """
        }
      }
    }
    
    stage('redis') {
      steps {
        container('container-redis') {
          sh """ 
            echo foo $foo
            echo Working in $POD_CONTAINER
            ls -l /var
          """
        }
      }
    }

  }
}