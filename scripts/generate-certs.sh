#!/bin/bash

# colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'
BRIGHT='\033[1m'

mkdir -p certs

echo "${GREEN}[Start]: Generating Self-Signed Certificate...${NC}"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout certs/nginx-selfsigned.key \
    -out certs/nginx-selfsigned.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"

echo "${GREEN}[Done]: Certificates generated in certs/ directory..${NC}"
