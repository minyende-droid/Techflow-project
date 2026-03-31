#!/bin/bash

URL="http://localhost/health"
MAX_RETRIES=5
RETRY_DELAY=3

echo "Starting health check..."

for i in $(seq 1 $MAX_RETRIES)
do
  echo "Attempt $i..."

  STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL)

  if [ "$STATUS_CODE" -eq 200 ]; then
    echo "✅ App is healthy!"
    exit 0
  fi

  echo "❌ Not ready yet (status: $STATUS_CODE)"
  sleep $RETRY_DELAY
done

echo "❌ App failed health check after $MAX_RETRIES attempts"
exit 1