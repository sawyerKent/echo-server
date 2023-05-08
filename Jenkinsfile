pipeline {
  agent any

  stages {
    stage('Clone repository') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/sawyerKent/echo-server.git']]])
      }
    }
    // stage('Initialize'){
    //     def dockerHome = tool 'myDocker'
    //     env.PATH = "${dockerHome}/bin:${env.PATH}"
    // }
    stage('Build Docker image') {
      steps {
        script {
          def dockerImage = docker.build('sawyerkent.jfrog.io/docker/my-echo-server:1.0.0', '.')
          def execContainer = docker.build('sawyerkent.jfrog.io/docker/my-echo-server:1.0.0-exec', '-f Dockerfile.exec .')
          def scratchContainer = docker.build('sawyerkent.jfrog.io/docker/my-echo-server:1.0.0', '-f Dockerfile.scratch .')
        }
      }
    }
    stage('Push Docker image to JFrog Artifactory') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: 'jfrog-creds', usernameVariable: 'JFROG_USERNAME', passwordVariable: 'JFROG_PASSWORD')]) {
            docker.withRegistry("https://sawyerkent.jfrog.io", 'docker') {
              dockerImage.push()
              execContainer.push()
              scratchContainer.push()
            }
          }
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        script {
          def image = 'sawyerkent.jfrog.io/docker/my-echo-server:1.0.0'
          def namespace = 'default'
          def deploymentName = 'echo-server'
          def replicas = 1

          kubernetesDeploy(
            kubeconfigId: 'my-kubeconfig',
            configs: 'configs',
            enableConfigSubstitution: true,
            namespace: namespace,
            replicas: replicas,
            deployments: [
              [
                name: deploymentName,
                label: deploymentName,
                image: image,
                ports: [
                  [name: 'http', containerPort: 8080]
                ]
              ]
            ]
          )
        }
      }
    }
  }
}

// pipeline {
//     agent any
    
//     stages {
//         stage('Checkout') {
//             steps {
//                 checkout scm
//             }
//         }
        
//         stage('Build Docker image') {
//             steps {
//                 sh 'docker build -t your-image-name .'
//             }
//         }
        
//         stage('Push Docker image to Artifactory') {
//             steps {
//                 withCredentials([usernamePassword(credentialsId: 'artifactory-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
//                     sh 'docker login -u $USERNAME -p $PASSWORD your-artifactory-url'
//                     sh 'docker tag your-image-name your-artifactory-url/your-image-name'
//                     sh 'docker push your-artifactory-url/your-image-name'
//                 }
//             }
//         }
        
//         stage('Deploy to Kubernetes cluster') {
//             steps {
//                 withKubeConfig([credentialsId: 'kubeconfig-credentials', serverUrl: 'https://your-kubernetes-server-url']) {
//                     sh 'kubectl apply -f your-deployment-file.yaml'
//                 }
//             }
//         }
//     }
// }
