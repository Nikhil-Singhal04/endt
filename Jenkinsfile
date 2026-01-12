pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        INSTANCE_ID = "i-080dcf258cf6af4c9"
    }

    stages {

        stage('Verify AWS CLI') {
            steps {
                sh 'aws --version'
            }
        }

        stage('Wait for EC2 Instance to be Ready') {
            steps {
                withCredentials([[
                  $class: 'AmazonWebServicesCredentialsBinding',
                  credentialsId: 'AWS-CREDS'
                ]]) {
                    sh '''
                    aws ec2 wait instance-status-ok \
                    --instance-ids $INSTANCE_ID \
                    --region $AWS_REGION
                    '''
                }
            }
        }

        stage('Post-Wait Action') {
            steps {
                echo "EC2 is ready, proceeding further"
            }
        }
    }
}
