pipeline {
  agent any

  environment {
    AWS_REGION = 'us-west-2'
    LAUNCH_TEMPLATE_ID = 'lt-096ba2151975b2c45' // Replace with your actual Launch Template ID
    ASG_NAME = 'my-auto-scaling-group'          // Replace with your actual Auto Scaling Group name
    AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
    AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
  }

  stages {
    stage('CheckOut SCM') {
      steps {
        script {
          checkout scm
        }
      }
    }

    stage('Packer Init') {
      steps {
        script {
          sh 'packer init .'
        }
      }
    }

    stage('Validate and Build AMI with Packer') {
      steps {
        script {
          sh 'packer validate packer.pkr.hcl'
          sh 'packer build packer.pkr.hcl | tee packer.log'
        }
      }
    }

    stage('Parse AMI ID') {
      steps {
        script {
          def log = readFile('packer.log')
          def matcher = log =~ /AMI: (ami-[a-z0-9]+)/

          if (matcher.find()) {
              env.NEW_AMI_ID = matcher.group(1)
              echo "✅ New AMI ID: ${env.NEW_AMI_ID}"
          } else {
              error "❌ Failed to parse AMI ID from packer.log"
          }
        }
      }
    }

    stage('Update Launch Template') {
      steps {
        script {
          sh """
            aws ec2 create-create-launch-template-version \
              --launch-template-id ${LAUNCH_TEMPLATE_ID} \
              --version-description "Updated to AMI ${NEW_AMI_ID}" \
              --source-version 1 \
              --launch-template-data '{"ImageId":"${NEW_AMI_ID}"}' \
              --region ${AWS_REGION}
          """
          echo "✅ Launch template updated with new AMI ID: ${env.NEW_AMI_ID}"
        }
      }
    }

    stage('Start ASG Instance Refresh') {
      steps {
        script {
          sh """
            aws autoscaling start-instance-refresh \
              --auto-scaling-group-name ${ASG_NAME} \
              --preferences MinHealthyPercentage=50,InstanceWarmup=300 \
              --region ${AWS_REGION}
              --query 'InstanceRefreshId' --output text
          """
        }
      }
    }
  }

  post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Please check the logs.'
        }
        always {
            archiveArtifacts artifacts: 'packer.log', fingerprint: true
        }
    }
}