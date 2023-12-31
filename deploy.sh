#!/bin/bash

# Set variables
DOCKER_IMAGE="harbor.xxxxxxx.com/rpservices/argo_hello-world_html"
DOCKER_TAG="latest"  # Or a dynamic tag based on your versioning strategy
DOCKER_REGISTRY="harbor.xxxxxxx.com"  # Example: docker.io for Docker Hub
REGISTRY_USERNAME="xxxxx"
REGISTRY_PASSWORD="xxxxxxx"
KUBE_MANIFEST="argocd/application.yaml"

# Ensure Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker does not seem to be running, please start Docker"
    exit 1
fi

# Build Docker image
echo "Building Docker image..."
# change directory
docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ./docker/

# Log in to Docker registry
echo "Logging into Docker registry ${DOCKER_REGISTRY}..."
echo ${REGISTRY_PASSWORD} | docker login -u ${REGISTRY_USERNAME} ${DOCKER_REGISTRY} --password-stdin

# Push Docker image to registry
echo "Pushing Docker image to registry..."
docker push ${DOCKER_IMAGE}:${DOCKER_TAG}

# Check for kubectl
if ! command -v kubectl &> /dev/null
then
    echo "kubectl could not be found, please install and configure it"
    exit 1
fi

# Apply Kubernetes manifest
echo "Applying Kubernetes manifest..."
kubectl apply -f ${KUBE_MANIFEST}

echo "Script execution completed!"
