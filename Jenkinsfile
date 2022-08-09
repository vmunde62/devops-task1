pipeline {
    agent any 
    stages {
        stage('Git Checkout') { 
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/vmunde62/devops-task1.git']]])
            }
        }
        stage('Build docker image') {
            steps {
                sh "sudo docker build -t nginx:noroot ."
            }
        }
        stage('Run trivy scan') {
            steps {
                sh "trivy image --exit-code 1 --severity HIGH,CRITICAL nginx:noroot"
            }
        }
        stage('Deploy helm chart') {
            steps {
                sh "helm upgrade --install nginx helm-task -n default"
            }

        }
    }
}