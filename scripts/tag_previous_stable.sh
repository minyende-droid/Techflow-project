#!/bin/bash

CONTAINER_NAME="flask-app"
DOCKER_USER="minyende"
IMAGE_NAME="flask-app"

echo "Finding current running container image..."

CURRENT_IMAGE=$(sudo docker inspect --format='{{.Config.Image}}' $CONTAINER_NAME)

if [ -z "$CURRENT_IMAGE" ]; then
  echo "No running container found. Skipping tagging."
  exit 0
fi

echo "Current image is: $CURRENT_IMAGE"

echo "Tagging as previous_stable..."
sudo docker tag $CURRENT_IMAGE $DOCKER_USER/$IMAGE_NAME:previous_stable

echo "Pushing previous_stable to DockerHub..."
echo "${DOCKER_PASSWORD}" | sudo docker login -u "${DOCKER_USER}" --password-stdin
sudo docker push $DOCKER_USER/$IMAGE_NAME:previous_stable

echo "previous_stable updated successfully"