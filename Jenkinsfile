pipeline {
    agent any

    environment {
        APP_NAME = "netflix-clone"
        APP_VERSION = "v1.0.0"
        DOCKER_IMAGE = "${APP_NAME}:${APP_VERSION}"
        DOCKER_HUB_USERNAME = "mydocker691"
    }

    stages {
        // 1️⃣ Checkout code from SCM
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://your-repo-url.git'
            }
        }

        // 2️⃣ Build Docker Image
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE, "--build-arg APP_VERSION=${APP_VERSION} .")
                }
            }
        }

        // 3️⃣ Push Docker Image to Docker Hub
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    script {
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker tag ${DOCKER_IMAGE} ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE}"
                        sh "docker push ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Build and push successful!'
        }
        failure {
            echo 'Build or push failed.'
        }
    }
}

