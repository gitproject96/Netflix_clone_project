pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        KUBECONFIG_FILE = credentials('kubeconfig')
    }

    stages {

        stage('Checkout SCM') {
            steps {
                git(
                    url: 'https://github.com/gitproject96/mini-banking-app2.0.git',
                    branch: 'main',
                    credentialsId: 'github-cred'
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Short Git commit hash
                    def COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    def IMAGE_TAG = "mydocker691/banking-app:${BUILD_NUMBER}-${COMMIT}"

                    // Build Docker image and pass APP_VERSION
                    sh """
                        docker build --build-arg APP_VERSION=${BUILD_NUMBER}-${COMMIT} -t ${IMAGE_TAG} .
                    """

                    // Save tag for later stages
                    env.IMAGE_TAG = IMAGE_TAG
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKERHUB_PSW', usernameVariable: 'DOCKERHUB_USER')]) {
                    sh "echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USER --password-stdin"
                    sh "docker push ${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
    steps {
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
            // Replace IMAGE_PLACEHOLDER only in the image line
            sh "sed -i '/image:/ s|IMAGE_PLACEHOLDER|${IMAGE_TAG}|' k8s/deployment.yaml"

            // Apply deployment and service
            sh "kubectl --kubeconfig=$KUBECONFIG apply -f k8s/deployment.yaml"
            sh "kubectl --kubeconfig=$KUBECONFIG apply -f k8s/service.yaml"

            // Rolling restart
            sh "kubectl --kubeconfig=$KUBECONFIG rollout restart deployment banking-app"
        }
    }
}

    }

    post {
        success {
            echo "✅ Pipeline completed successfully! Deployed image: ${IMAGE_TAG}"
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
