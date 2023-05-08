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
          env.DOCKER_IMAGE = docker.build('sawyerkent.jfrog.io/docker/my-echo-server:1.0.0', '.').id
        }
      }
    }
    stage('Push Docker image to JFrog Artifactory') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: 'jfrog-creds', usernameVariable: 'JFROG_USERNAME', passwordVariable: 'JFROG_PASSWORD')]) {
            docker.withRegistry("https://sawyerkent.jfrog.io", 'jfrog-creds') {
              def dockerImage = docker.image(env.DOCKER_IMAGE)
              dockerImage.push()
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

            withKubeConfig([credentialsId: 'my-kubeconfig', contextName: 'your-kube-context']) {
                // Substitute variables in the template
                sh 'envsubst < configs/deployment_template.yaml > configs/deployment.yaml'

                // Deploy the application
                sh "kubectl apply -f configs/deployment.yaml -n ${namespace}"
                sh "kubectl set image deployment/${deploymentName} ${deploymentName}=${image} -n ${namespace}"
                sh "kubectl scale deployment/${deploymentName} --replicas=${replicas} -n ${namespace}"
            }
        }
    }
}

    // stage('Deploy to Kubernetes') {
    //   steps {
    //     script {
    //       def image = 'sawyerkent.jfrog.io/docker/my-echo-server:1.0.0'
    //       def namespace = 'default'
    //       def deploymentName = 'echo-server'
    //       def replicas = 1

    //       kubernetesDeploy(
    //         kubeconfigId: 'my-kubeconfig',
    //         configs: 'configs',
    //         enableConfigSubstitution: true,
    //         namespace: namespace,
    //         replicas: replicas,
    //         deployments: [
    //           [
    //             name: deploymentName,
    //             label: deploymentName,
    //             image: image,
    //             ports: [
    //               [name: 'http', containerPort: 8080]
    //             ]
    //           ]
    //         ]
    //       )
    //     }
    //   }
    // }
  }
}


// pipeline {
//   agent any

//   def dockerImage

//   stages {
//     stage('Clone repository') {
//       steps {
//         checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/sawyerKent/echo-server.git']]])
//       }
//     }
//     // stage('Initialize'){
//     //     def dockerHome = tool 'myDocker'
//     //     env.PATH = "${dockerHome}/bin:${env.PATH}"
//     // }
//     stage('Build Docker image') {
//       steps {
//         script {
//           dockerImage = docker.build('sawyerkent.jfrog.io/docker/my-echo-server:1.0.0', '.')
//         //   def execContainer = docker.build('sawyerkent.jfrog.io/docker/my-echo-server:1.0.0-exec', '-f Dockerfile.exec .')
//         //   def scratchContainer = docker.build('sawyerkent.jfrog.io/docker/my-echo-server:1.0.0', '-f Dockerfile.scratch .')
//         }
//       }
//     }
//     stage('Push Docker image to JFrog Artifactory') {
//       steps {
//         script {
//           withCredentials([usernamePassword(credentialsId: 'jfrog-creds', usernameVariable: 'JFROG_USERNAME', passwordVariable: 'JFROG_PASSWORD')]) {
//             docker.withRegistry("https://sawyerkent.jfrog.io", 'jfrog-creds') {
//               dockerImage.push()
//             //   execContainer.push()
//             //   scratchContainer.push()
//             }
//           }
//         }
//       }
//     }
//     stage('Deploy to Kubernetes') {
//       steps {
//         script {
//           def image = 'sawyerkent.jfrog.io/docker/my-echo-server:1.0.0'
//           def namespace = 'default'
//           def deploymentName = 'echo-server'
//           def replicas = 1

//           kubernetesDeploy(
//             kubeconfigId: 'my-kubeconfig',
//             configs: 'configs',
//             enableConfigSubstitution: true,
//             namespace: namespace,
//             replicas: replicas,
//             deployments: [
//               [
//                 name: deploymentName,
//                 label: deploymentName,
//                 image: image,
//                 ports: [
//                   [name: 'http', containerPort: 8080]
//                 ]
//               ]
//             ]
//           )
//         }
//       }
//     }
//   }
// }
