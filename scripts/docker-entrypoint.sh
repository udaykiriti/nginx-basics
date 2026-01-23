#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo "${GREEN}[Start]: Starting Backend 1...${NC}"
python3 /app/scripts/backend.py 8081 &

echo "${GREEN}[Start]: Starting Backend 2...${NC}"
python3 /app/scripts/backend.py 8082 &

echo "${GREEN}[Start]: Starting Nginx...${NC}"
nginx -g "daemon off;"
