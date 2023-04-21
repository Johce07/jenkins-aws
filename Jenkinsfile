pipeline {
    agent any
    environment{
        BUCKET = "azure-devops-aws"
    }

    stages {
        stage('deploy to s3') {
            steps {
                withAWS(credentials: 'azurecon', region: 'us-east-1') {
                    bat 'aws s3 sync . s3://$BUCKET --exclude ".git/*"'
                    bat 'aws s3 ls s3://$BUCKET'
                }
            }
        }
    }
}