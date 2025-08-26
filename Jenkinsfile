pipeline {
    agent any

    environment {
        AZURE_RESOURCE_GROUP = 'project7'
        AZURE_WEBAPP_NAME    = 'kimi-web-app-jenkins-3'
        JAR_NAME             = 'pattelakrishnaspringpetclinic.jar'
    }

    stages {
        stage('Build with Maven') {
            steps {
                echo 'Building the project...'
                sh 'mvn clean package -Dcheckstyle.skip=true'
            }
        }

        stage('Archive Artifact') {
            steps {
                echo 'Archiving JAR...'
                sh 'mv target/*.jar target/${JAR_NAME}'
                archiveArtifacts artifacts: "target/${JAR_NAME}", fingerprint: true
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID',        variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET',    variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_SUBSCRIPTION_ID',  variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'ARM_TENANT_ID',        variable: 'ARM_TENANT_ID')
                ]) {
                    dir('infra') {
                        sh '''
                            export ARM_CLIENT_ID=$ARM_CLIENT_ID
                            export ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET
                            export ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID
                            export ARM_TENANT_ID=$ARM_TENANT_ID

                            terraform init
                            terraform validate
                            terraform plan
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID',        variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET',    variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_SUBSCRIPTION_ID',  variable: 'ARM_SUBSCRIPTION_ID'),
                    string(credentialsId: 'ARM_TENANT_ID',        variable: 'ARM_TENANT_ID')
                ]) {
                    dir('infra') {
                        sh '''
                            export ARM_CLIENT_ID=$ARM_CLIENT_ID
                            export ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET
                            export ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID
                            export ARM_TENANT_ID=$ARM_TENANT_ID

                            terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        stage('Deploy to Azure Web App') {
            steps {
                withCredentials([
                    string(credentialsId: 'ARM_CLIENT_ID',     variable: 'ARM_CLIENT_ID'),
                    string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
                    string(credentialsId: 'ARM_TENANT_ID',     variable: 'ARM_TENANT_ID')
                ]) {
                    sh '''
                        az login --service-principal \
                            -u $ARM_CLIENT_ID \
                            -p $ARM_CLIENT_SECRET \
                            --tenant $ARM_TENANT_ID

                        az webapp deploy \
                            --resource-group $AZURE_RESOURCE_GROUP \
                            --name $AZURE_WEBAPP_NAME \
                            --type jar \
                            --src-path target/$JAR_NAME
                    '''
                }
            }
        }
    }
}
