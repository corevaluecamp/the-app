pipeline {
    agent any
  stages {
    stage('Deploy') {
      steps {
         load "/var/lib/jenkins/.envvars/var.groovy"
         echo 'Deploying monitoring jsons to S3 bucket'
         sh "python3 s3.py Node_Multiple-1576160531663.json ${env.BUCKET_NAME} Node_Multiple-1576160531663.json"
         sh "python3 s3.py Node_Single-1576185900325.json ${env.BUCKET_NAME} Node_Single-1576185900325.json"
      }
    }
  }
}
