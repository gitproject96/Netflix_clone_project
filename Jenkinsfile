pipeline {
    agent any

    environment {
        APP_NAME = "netflix-clone"
        APP_VERSION = "v1.0.0"
        DOCKER_IMAGE = "${APP_NAME}:${APP_VERSION}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://your-repo-url.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE, "--build-arg APP_VERSION=${APP_VERSION} .")
                }
            }
        }

        stage('Run Container Locally') {
            steps {
                script {
                    sh "docker rm -f ${APP_NAME} || true"
                    sh "docker run -d --name ${APP_NAME} -p 5000:5000 ${DOCKER_IMAGE}"
                }
            }
        }

        // Optional: push to Docker Hub
        /*
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker tag ${DOCKER_IMAGE} yourdockerhubusername/${DOCKER_IMAGE}"
                    sh "docker push yourdockerhubusername/${DOCKER_IMAGE}"
                }
            }
        }
        */
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}

