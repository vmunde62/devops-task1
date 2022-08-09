# Introduction

The task is to create Kubernetes deployment with a secret mounted as environment variable.

  

# Prerequisites

The Prerequisites need for installtion,

1. Docker - Containerization Tool

2. Jenkins lts - For running the pipeline

3. Minikube - Local kubernetes

4. Helm - Kubernetes deployment manager

5. Trivy - Scanner for vulnerabilities in container images

## Setting up prerequisites
The installation instruction is for debian/ubuntu based linux distribution. 
As docker installation requires to reboot the system, we have to first install docker, using script.

    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
  After installing docker, Reboot the system.
  
  For remaining prerequisites, use **prerequisites.sh** script to install and setup remaining tools.
  

    ./prerequisites.sh

  
  

# Setup

After installing prerequisites, Open Jenkins webpage on http://localhost:8080 or http://[PubicIP]:8080 for server. Then unlock the jenkins and setup a jenkins account.


Login to created jenkins account.


Then create a New pipeline job, A configuration page will open.
 

At the bottom of the page, Select the defination file as '**Pipeline script from SCM**' .


Enter the This Repository url and select the main branch, Then save the pipeline. 


This will create a New jenkins pipeline.


## Trivy Image scanner
In the pipeline stages, The trivy scanner is set to fail the pipeline, if the docker image contains any vulnerabilty of level **HIGH** or **CRITICAL** .

To bypass this you can change the **--exit-code** in Jenkinsfile, from

    trivy image --exit-code 1 --severity HIGH,CRITICAL <image name>
To

    trivy image --exit-code 0 --severity HIGH,CRITICAL <image name>

This will allow pipeline to continue, even if trivy finds any vulnerabilty of any level.

## Running container as non-root
The nginx image from official docker repository is already configured as a non-root user. So we dont have to mention different user in kubernetes deployment yaml.

In case if we have to use other user than root, we can configure this by adding security context under container spec in deployment yaml. The uid of the user or group need to be replaced.

    securityContext:
	    runAsNonRoot: true
	    runAsUser: 1001
	    runAsGroup: 1001


## Jenkins Troubleshoot
If you are getting this error in pipeline,

    # Jenkins sudo: no tty present and no askpass program specified with NOPASSWD

you will need to add **jenkins** user in /etc/sudoers file.
To add, Open /etc/sudoers file in vim editor and add the following line at the end of file.

    jenkins ALL=(ALL) NOPASSWD: ALL
save the file using override option ':wq!'.


