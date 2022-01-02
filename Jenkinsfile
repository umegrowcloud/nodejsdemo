pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '2')) 
    }
    environment {
        AWS_ACCOUNT_ID="XXXXXXXXXXXXXXXXX"
        AWS_DEFAULT_REGION="us-east-1" 
        IMAGE_REPO_NAME="demo-app"
        IMAGE_TAG="${BUILD_NUMBER}.0"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        serviceName ="demonode"
    }
   
    stages {
        
         stage('Logging into AWS ECR') {
            steps {
                script {
                sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
                 
            }
        }
        
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/umegrowcloud/nodejsdemo.git']]])     
            }
        }
  
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
         }
        }
      }
      
    stage('Deploy image to AWS') {
            steps {
                script {
                        withEnv(["serviceName=${serviceName}","ImageURI=${REPOSITORY_URI}:${IMAGE_TAG}"]) {
                            sh "ls -la"
                            sh "chmod +x cfn.sh"
                            sh "./cfn.sh"
                        }
                }
            }
        }
    }
}
