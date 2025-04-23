pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'marwansabry'
        IMAGE_NAME = 'my-nginx-app'
        DOCKERHUB_CRED_ID = 'dockerhub-credentials'
        S3_BUCKET_NAME = 'eb-deploy-artifacts'
        EB_APPLICATION_NAME = 'ElasticBeanstalkApplication'
        EB_ENVIRONMENT_NAME = 'ElasticBeanstalkEnvironment'
        AWS_CRED_ID = 'aws-credentials'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = env.BUILD_NUMBER
                    sh "docker build -t ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${imageTag} ."
                    sh "docker build -t ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Run Automated Tests') {
            steps {
                echo "No Test Applied."
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKERHUB_CRED_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo \"\$DOCKER_PASS\" | docker login -u \"\$DOCKER_USER\" --password-stdin"
                        def imageTag = env.BUILD_NUMBER
                        sh "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${imageTag}"
                        sh "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Prepare Deployment Artifact') {
            steps {
                script {
                    def dockerrunContent = """
                    {
                      "AWSEBDockerrunVersion": "1",
                      "Image": {
                        "Name": "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest",
                        "Update": "true"
                      },
                      "Ports": [
                        {
                          "ContainerPort": "8080"
                        }
                      ],
                      "Logging": "/var/log/nginx"
                    }
                    """
                    writeFile file: 'Dockerrun.aws.json', text: dockerrunContent
                    sh "zip deploy.zip Dockerrun.aws.json"
                }
            }
        }

        stage('Upload Artifact to S3') {
            steps {
                script {
                    withCredentials([aws(credentialsId: AWS_CRED_ID)]) {
                        def s3Key = "app-deploy-${env.BUILD_NUMBER}.zip"
                        sh "aws s3 cp deploy.zip s3://${S3_BUCKET_NAME}/${s3Key}"
                    }
                }
            }
        }

        stage('Deploy to Elastic Beanstalk') {
            steps {
                script {
                    withCredentials([aws(credentialsId: AWS_CRED_ID)]) {
                        def versionLabel = "build-${env.BUILD_NUMBER}"
                        def s3Key = "app-deploy-${env.BUILD_NUMBER}.zip"
                        sh "aws elasticbeanstalk create-application-version --application-name ${EB_APPLICATION_NAME} --version-label ${versionLabel} --source-bundle S3Bucket=${S3_BUCKET_BUCKET},S3Key=${s3Key} --auto-create-application"
                        sh "aws elasticbeanstalk update-environment --environment-name ${EB_ENVIRONMENT_NAME} --version-label ${versionLabel}"
                    }
                }
            }
        }

        stage('Verification') {
            steps {
                echo "Deployment pipeline finished. Please manually verify the application is accessible."
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
    }
}