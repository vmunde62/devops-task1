pipeline {
    agent any 
    stages {
        stage('Git Checkout') { 
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/vmunde62/devops-task1.git']]])
            }
        }
        stage('Run trivy scan') {
            steps {
                sh "trivy image --exit-code 1 --severity HIGH,CRITICAL nginx:stable"
            }
        }
        stage('Deploy helm chart') {
            steps {
                sh "helm upgrade --install nginx helm-task -n default"
            }

        }
    }
}