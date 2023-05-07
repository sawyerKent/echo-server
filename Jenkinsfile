pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker image') {
            steps {
                sh 'docker build -t your-image-name .'
            }
        }
        
        stage('Push Docker image to Artifactory') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'artifactory-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'docker login -u $USERNAME -p $PASSWORD your-artifactory-url'
                    sh 'docker tag your-image-name your-artifactory-url/your-image-name'
                    sh 'docker push your-artifactory-url/your-image-name'
                }
            }
        }
        
        stage('Deploy to Kubernetes cluster') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig-credentials', serverUrl: 'https://your-kubernetes-server-url']) {
                    sh 'kubectl apply -f your-deployment-file.yaml'
                }
            }
        }
    }
}
