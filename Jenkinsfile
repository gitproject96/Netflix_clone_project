pipeline {
    agent any

    environment {
        APP_NAME = "netflix-clone"
        APP_VERSION = "v1.0.${BUILD_NUMBER}"  // Auto incremented with each build
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
                    // Groovy-safe interpolation inside quotes
                    docker.build("${DOCKER_IMAGE}", "--build-arg APP_VERSION=${APP_VERSION} .")
                }
            }
        }

        // 3️⃣ Health Check
        stage('Health Check') {
            steps {
                script {
                    sh """
                    docker rm -f ${APP_NAME} || true
                    docker run -d --name ${APP_NAME} -p 5000:5000 ${DOCKER_IMAGE}
                    STATUS=\$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000)
                    if [ \$STATUS -ne 200 ]; then
                        echo "Health check failed!"
                        exit 1
                    else
                        echo "App is running and healthy."
                    fi
                    docker rm -f ${APP_NAME}
                    """
                }
            }
        }

        // 4️⃣ Push Docker Image to Docker Hub (only main branch)
        stage('Push to Docker Hub') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    script {
                        // Use single $ for shell variables; Groovy interpolation handled correctly
                        sh "echo \$PASS | docker login -u \$USER --password-stdin"
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
            echo "Build, health check, and push successful! Version: ${APP_VERSION}"
        }
        failure {
            echo 'Build or deployment failed.'
        }
    }
}

