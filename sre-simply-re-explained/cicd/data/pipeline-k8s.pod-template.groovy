podTemplate(
    containers: [
        containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent:4.3-4-alpine'),
        containerTemplate(name: 'container-nginx', image: 'nginx:1.15.9'),
        containerTemplate(name: 'container-redis', image: 'redis:alpine'),
    ],
    envVars: [envVar(key: 'foo', value: 'abc')],
    volumes: [emptyDirVolume(mountPath: '/var/my-storage', memory: false)]
) {

  node(POD_LABEL) {
    stage('none') {
        sh """ 
            touch /var/my-storage/$foo
            ls -l /var/my-storage
        """
    }
    
    stage('jnlp') {
      container('jnlp') {
        sh """ 
            echo Working in $POD_CONTAINER
            ls -l /var/my-storage
        """
      }
    }

    stage('nginx') {
      container('container-nginx') {
        sh """ 
            echo Working in $POD_CONTAINER
            ls -l /var/my-storage
        """
      }
    }
    
    stage('redis') {
      container('container-redis') {
        sh """ 
            echo Working in $POD_CONTAINER
            ls -l /var/my-storage
        """
      }
    }
  }
}
