#!/bin/bash

# Set variables
AWS_REGION="eu-west-2"
AWS_ACCOUNT_ID="954039218418"
ECR_REPO="pg-postgis-pgvector"
# Default tag values (can be overridden with arguments)
POSTGRES_VERSION=${1:-16}
POSTGIS_VERSION=${2:-3.5}
TAG="${POSTGRES_VERSION}-${POSTGIS_VERSION}-0.7.0"

# Login to AWS ECR
# aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build and push for both linux and arm platforms
# PLATFORMS="linux/amd64,linux/arm64"
PLATFORMS="linux/arm64"
IMAGE_NAME="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO"

# Build the image with buildx for both platforms, passing arguments to Dockerfile
docker buildx build \
    --platform $PLATFORMS \
    --build-arg POSTGRES_VERSION="$POSTGRES_VERSION" \
    --build-arg POSTGIS_VERSION="$POSTGIS_VERSION" \
    -t "$IMAGE_NAME:$TAG-linux" \
    -t "$IMAGE_NAME:$TAG-arm" \
    --push .
