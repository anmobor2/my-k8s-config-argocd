pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'registry.hub.docker.com'
        DOCKER_REPO = 'yourusername/hello-world'
        REGISTRY_CREDENTIALS_ID = 'docker-hub-credentials'  // ID for Docker Hub credentials stored in Jenkins
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    def gitCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    def newTag = "v${env.BUILD_NUMBER}-${gitCommit}"

                    // Building Docker image with newTag
                    docker.build("${DOCKER_REPO}:${newTag}")

                    // Login to Docker Hub
                    docker.withRegistry("https://${DOCKER_REGISTRY}", env.REGISTRY_CREDENTIALS_ID) {
                        // Pushing Docker image with newTag
                        docker.image("${DOCKER_REPO}:${newTag}").push()

                        // Also tag and push as 'latest'
                        docker.image("${DOCKER_REPO}:${newTag}").push("latest")
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply Kubernetes manifests
                    // Ensure Jenkins has credentials and context to access your Kubernetes cluster
                    sh 'kubectl apply -f path/to/your-argocd-application.yaml'
                }
            }
        }
    }
}
