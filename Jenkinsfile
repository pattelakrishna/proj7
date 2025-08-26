pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = '038c6474-ab85-462d-967c-7fe666cd99e7'
        ARM_CLIENT_SECRET   = '-T68Q~L2YhSXkNcrwID5XaFhw4VBlD42LC6xIdpd'
        ARM_SUBSCRIPTION_ID = 'd6e154dc-0c67-4143-9261-e8b06141c24f'
        ARM_TENANT_ID       = 'e8e808be-1f06-40a2-87f1-d3a52b7ce684'
    }

    stages {
        stage('Build with Maven') {
            steps {
                echo 'Building the project with Maven...'
                sh 'mvn clean package -Dcheckstyle.skip=true'
            }
        }

        stage('Archive Artifact') {
            steps {
                echo 'Renaming and archiving the JAR file...'
                sh 'mv target/*.jar target/pattelakrishnaspringpetclinic.jar'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Terraform Init') {
            steps {
                dir('infra') {
                    echo 'Initializing Terraform...'
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('infra') {
                    echo 'Validating Terraform configuration...'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('infra') {
                    echo 'Creating Terraform plan...'
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('infra') {
                    echo 'Applying Terraform configuration...'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                echo 'Deploying application to Azure Web App...'
                sh '''
                    az login --service-principal \
                        -u $ARM_CLIENT_ID \
                        -p $ARM_CLIENT_SECRET \
                        --tenant $ARM_TENANT_ID

                    az webapp deploy \
                        --resource-group project7 \
                        --name kimi-web-app-jenkins-3 \
                        --type jar \
                        --src-path target/pattelakrishnaspringpetclinic.jar
                '''
            }
        }
    }
}
