pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    environment {
        ARM_CLIENT_ID        = '038c6474-ab85-462d-967c-7fe666cd99e7'
        ARM_CLIENT_SECRET    = 'EEz8Q~abZpXjRWMO1OVSAwgpFcTiIsBgRKqifcc3'
        ARM_SUBSCRIPTION_ID  = 'd6e154dc-0c67-4143-9261-e8b06141c24f'
        ARM_TENANT_ID        = 'e8e808be-1f06-40a2-87f1-d3a52b7ce684'
    }

    stages {
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -Dcheckstyle.skip=true'
            }
        }

        stage('Archive Artifact') {
            steps {
                sh 'mv target/*.jar target/pattelakrishnaspringpetclinic.jar'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Terraform Init') {
            steps {
                dir('infra') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('infra') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('infra') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('infra') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                sh '''
                    az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
                    az webapp deploy --resource-group project7 \
                                     --name kimi-web-app-jenkins-3 \
                                     --type jar \
                                     --src-path target/pattelakrishnaspringpetclinic.jar
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
