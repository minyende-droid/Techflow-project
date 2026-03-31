#!/bin/bash

IMAGE_NAME="minyende/flask-app:previous_stable"
CONTAINER_NAME="flask-app"
URL="http://localhost/health"

echo "⚠️ Health check failed. Starting rollback..."

# Stop and remove current container
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Pull previous stable image
echo "Pulling previous stable image..."
docker pull $IMAGE_NAME

# Run previous stable container
echo "Starting rollback container..."
docker run -d -p 80:5000 --name $CONTAINER_NAME $IMAGE_NAME

# Verify rollback
echo "Verifying rollback..."

sleep 5

STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ "$STATUS_CODE" -eq 200 ]; then
  echo "✅ Rollback successful!"
  exit 0
else
  echo "❌ Rollback failed!"
  exit 1
fi