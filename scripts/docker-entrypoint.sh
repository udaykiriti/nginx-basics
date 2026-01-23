#!/bin/bash

echo "Starting Backend 1..."
python3 /app/scripts/backend.py 8081 &

echo "Starting Backend 2..."
python3 /app/scripts/backend.py 8082 &

echo "Starting Nginx..."
nginx -g "daemon off;"
