pipeline {
    agent any

    stages {
        stage('Build for production') {
            steps {
                sh "docker build -t perl-5.20:${env.BRANCH_NAME} ."
            }
        }

        stage('Build for development') {
            steps {
                sh "docker build -t perl-5.20-dev:${env.BRANCH_NAME} -f Dockerfile.dev ."
            }
        }
    }
}