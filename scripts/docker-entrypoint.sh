#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}[Start]: Starting Backend 1...${NC}"
python3 /app/scripts/backend.py 8081 &

echo -e "${GREEN}[Start]: Starting Backend 2...${NC}"
python3 /app/scripts/backend.py 8082 &

echo -e "${GREEN}[Start]: Starting Backend V2...${NC}"
python3 /app/scripts/backend-v2.py 8083 &

echo -e "${GREEN}[Start]: Starting Backend Green...${NC}"
python3 /app/scripts/backend-green.py 8084 &

echo -e "${GREEN}[Start]: Starting Nginx...${NC}"
nginx -g "daemon off;"
