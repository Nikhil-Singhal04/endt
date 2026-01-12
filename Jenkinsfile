pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"              // change if needed
        INSTANCE_ID = "i-0649de9b55aa99bf6"    // your EC2 instance ID
        EC2_USER = "ubuntu"                   // default Ubuntu user
        EC2_IP = "23.22.109.158"         // from terraform output
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
                    echo "Waiting for EC2 instance to pass status checks..."
                    aws ec2 wait instance-status-ok \
                      --instance-ids $INSTANCE_ID \
                      --region $AWS_REGION
                    echo "EC2 instance is ready"
                    '''
                }
            }
        }

        stage('Verify Web Service via SSH using curl') {
            steps {
                sshagent(credentials: ['ec2-ssh-key']) {
                    sh '''
                    echo "Checking web service status on EC2..."

                    STATUS=$(ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP \
                      "curl -o /dev/null -s -w '%{http_code}' http://localhost")

                    if [ "$STATUS" = "200" ]; then
                        echo "SUCCESS: Web service is running (HTTP 200 OK)"
                    else
                        echo "FAILURE: Web service returned HTTP $STATUS"
                        exit 1
                    fi
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully. EC2 and web service are healthy."
        }
        failure {
            echo "Pipeline failed. EC2 or web service health check failed."
        }
    }
}
