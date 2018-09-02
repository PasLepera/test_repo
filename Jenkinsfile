
properties([
  parameters([
    booleanParam(name: 'persistent_volume', defaultValue: true, description: 'Create new pvc if necessary'),
    booleanParam(name: 'registry', defaultValue: false, description: 'Create new registry if necessary'),
    booleanParam(name: 'build_nginx', defaultValue: true, description: 'Build nginx container image'),
    booleanParam(name: 'push_nginx', defaultValue: true, description: 'Push builded nginx container image to registry'),
  ])
])

def label = "jenkins-${JOB_NAME}-${BUILD_NUMBER}".replace('/','-')

podTemplate(
  label: label,
  name: label,
  namespace: "jenkins",
  serviceAccount: "jenkins",
  envVars: [
    envVar(key: 'CONTAINER_VERSION', value: "${BUILD_ID}"),
  ],
  containers: [
  	containerTemplate(
      name: 'jnlp',
      image: 'jenkins/jnlp-slave:alpine',
      args: '${computer.jnlpmac} ${computer.name}',
    ),
  containerTemplate(
      name: 'dind',
      image: 'docker:stable-dind',
      privileged: true,
      ttyEnabled: true,
    ),
  ]
) 

{
  node(label) {
  	stage('Clone repo') {
      git url: 'ssh://git@stash.ibuildings.ws:7999/cloud/drupal8php70.git',
      credentialsId: 'IBC_bitbucket',
      branch: 'master'
    }
    stage('Create tmp artifacts directory') {
    	sh "set -x && \
            mkdir \${WORKSPACE}/build_artifacts/"
    }
    container('terraform') {
      if (params.registry) {
        stage('Create container registry') {
          dir('terraform/ecr') {
            sh "set -x && \
                terraform init && \
                yes yes | terraform apply -input=false"
          }
        }
      }
      stage('Get containers registry url') {
        dir('terraform/ecr') {
          sh "set -x && \
              terraform init && \
          	  terraform output drupal_ecr_url > \${WORKSPACE}/build_artifacts/drupal_registry_url && \
              terraform output drupal_nginx_ecr_url > \${WORKSPACE}/build_artifacts/drupal_nginx_registry_url"
        }
      }
		}
    stage('Get docker login credentials') {
        container('aws-cli') {
            sh "set -x && \
                aws --region eu-west-1 ecr get-login --no-include-email > \${WORKSPACE}/build_artifacts/docker_login"
        }
    }
    if (params.build_drupal || params.build_nginx) {
      stage('Build docker containers') {
        container('dind') {
          def builds = [:]

          if (params.build_drupal) {
            builds['Build drupal docker container image'] = {
              stage('Build drupal docker container image') {
                dir('docker/drupal') {
            	    sh "set -x && \
                    	docker build \
                    	-t \$(cat \${WORKSPACE}/build_artifacts/drupal_registry_url):v\${CONTAINER_VERSION} \
		        	      	-t \$(cat \${WORKSPACE}/build_artifacts/drupal_registry_url):latest \
                    	."
                }
              }
            }
          }
          if (params.build_nginx) {
            builds['Build drupal nginx docker container image'] = {
              stage('Build drupal nginx docker container image') {
                dir('docker/nginx') {
            	    sh "set -x && \
                    	docker build \
                    	-t \$(cat \${WORKSPACE}/build_artifacts/drupal_nginx_registry_url):v\${CONTAINER_VERSION} \
		        	      	-t \$(cat \${WORKSPACE}/build_artifacts/drupal_nginx_registry_url):latest \
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
              cat \${WORKSPACE}/build_artifacts/docker_login && \
              cat \${WORKSPACE}/build_artifacts/docker_login | sh"
        }
        stage('Push docker containers to registry') {
          def builds = [:]

          if (params.push_nginx) {
            builds['Push drupal nginx docker container to registry (v)'] = {
              stage('Push drupal nginx docker container to registry (v)') {
                sh "set -x && \
                    docker push \$(cat \${WORKSPACE}/build_artifacts/drupal_nginx_registry_url):v\${CONTAINER_VERSION}"
              }
            }
            builds['Push drupal nginx docker container to registry (latest)'] = {
              stage('Push drupal nginx docker container to registry (latest)') {
			    	    sh "set -x && \
                    docker push \$(cat \${WORKSPACE}/build_artifacts/drupal_nginx_registry_url):latest"
              }
            }
          }
          parallel builds
        }
      }  
    }
    stage('Collect container build logs') {
			containerLog('jnlp')
			containerLog('terraform')
			containerLog('aws-cli')
			containerLog('dind')
    }
  }
}
