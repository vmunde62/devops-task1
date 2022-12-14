#!/bin/bash
# Install prerequisites required

# Install minikube
echo 'Intalling minikube..'
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb > /dev/null 2>&1
sudo dpkg -i minikube_latest_amd64.deb > /dev/null
echo

# Install kubectl
echo 'Installing kubectl..'
sudo apt-get update > /dev/null
sudo apt-get install -y apt-transport-https ca-certificates curl > /dev/null
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
sudo apt-get update > /dev/null
sudo apt-get install -y kubectl > /dev/null
echo

# Install Helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list > /dev/null
sudo apt-get update > /dev/null
sudo apt-get install helm -y > /dev/null

# Install jenkins-lts
echo 'Installing jenkins-lts..'
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update > /dev/null
sudo apt-get install fontconfig openjdk-11-jre -y > /dev/null
sudo apt-get install jenkins -y > /dev/null
sleep 2
sudo systemctl start jenkins > /dev/null
echo

# Install trivy
echo 'Installing trivy..'
wget https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.deb > /dev/null 2>&1
sudo dpkg -i trivy_0.18.3_Linux-64bit.deb > /dev/null 2>&1
echo

# Start Minikube cluster
echo 'Starting minikube cluster'
minikube start
sleep 4
echo

# Setting kubernetes auth for jenkins
echo 'Setting Kubernetes access for jenkins..'
sudo cp -r $HOME/.minikube /var/lib/jenkins/
sudo cp -r $HOME/.kube /var/lib/jenkins/
sudo sed -i "s+$HOME+/var/lib/jenkins+g" /var/lib/jenkins/.kube/config
sleep 2
sudo chown -R jenkins:jenkins /var/lib/jenkins 
sleep 2
sudo systemctl start jenkins
echo
echo 'Done.'