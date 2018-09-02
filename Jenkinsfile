
properties([
  parameters([
    booleanParam(name: 'build_nginx', defaultValue: true, description: 'Build nginx container image'),
    booleanParam(name: 'push_nginx', defaultValue: true, description: 'Push builded nginx container image to registry'),
    booleanParam(name: 'app_deploy', defaultValue: true, description: 'Push builded nginx container image to kubernetes'),
  ])
])

def label = "my-release-jenkins-slave"
def NGINXREGISTRY = "registry:5000/nginx:1.8"
def NAMESPACEVAL = "default"

podTemplate(
  label: label,
  name: label,
  namespace: "test_jenkins",
  serviceAccount: "test_jenkins",
  envVars: [
    envVar(key: 'CONTAINER_VERSION', value: "${BUILD_ID}"),
  ],
  containers: [
  	containerTemplate(
      name: 'jnlp',
      image: 'jenkins/jnlp-slave:latest',
      args: '${computer.jnlpmac} ${computer.name}',
    ),
    containerTemplate(
      name: 'dind',
      image: 'docker:stable-dind',
      privileged: true,
      ttyEnabled: true,
    ),
    containerTemplate(
      name: 'helm',
      image: 'lachlanevenson/k8s-helm:v2.8.2',
      command: 'cat',
      ttyEnabled: true,
    ),
  ]
) 

{
  node(label) {
  	stage('Clone repo') {
      git url: 'https://github.com/PasLepera/test_repo.git',
      branch: 'master'
    }
    stage('Create tmp artifacts directory') {
    	sh "set -x && \
            mkdir \${WORKSPACE}/build_artifacts/"
    }
    if (params.build_nginx) {
      stage('Build docker containers') {
        container('dind') {
          def builds = [:]
          if (params.build_nginx) {
            builds['Build nginx docker container image'] = {
              stage('Build nginx docker container image') {
                dir('docker/nginx') {
            	    sh "set -x && \
                    	docker build \
                    	-t \${NGINXREGISTRY}:v\${CONTAINER_VERSION} \
                    	."
                }
              }
            }
          }

          parallel builds
        }
      }
    }
    if (params.push_nginx) {
      container('dind') {
    	stage('Log docker in to container registry') {
        	sh "set -x && \
              docker login registry:5000"
        }
        stage('Push docker containers to registry') {
          def builds = [:]

          if (params.push_nginx) {
            builds['Push nginx docker container to registry (v)'] = {
              stage('Push nginx docker container to registry (v)') {
                sh "set -x && \
                    docker push \${NGINXREGISTRY}:v\${CONTAINER_VERSION}"
              }
            }
            builds['Push nginx docker container to registry (latest)'] = {
              stage('Push nginx docker container to registry (latest)') {
			    	    sh "set -x && \
                    docker push \${NGINXREGISTRY}::latest"
              }
            }
          }
          parallel builds
        }
      }
    }  
    container('helm') {
      if (params.app_deploy) {
        dir('helm') {
          stage('Deploy application') {
            sh "set -x && \
                helm upgrade --wait --timeout 900 --install test-nginx ./templates -f values.yaml --namespace \${NAMESPACEVAL} && \
                helm history test-nginx"
          }
        }
      }
    }
    stage('Collect container build logs') {
			containerLog('jnlp')
			containerLog('dind')
			containerLog('helm')
    }
  }
}
