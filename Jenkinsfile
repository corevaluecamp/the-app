pipeline {
    agent any
  stages {
    stage('requirements') {
      steps {
        sh 'gem install compass'
      }
    }
    stage('build') {
      steps {
        sh './gradlew -p microservice/frontend/catalog bower grunt_build --stacktrace
            ./gradlew -p microservice/frontend/catalog prepareDeb buildDeb --stacktrace'
      }
    }
    stage('test') {
      steps {
        sh 'echo "test"'
      }   
    }
  }
}
