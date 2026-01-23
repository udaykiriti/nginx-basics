#!/bin/bash

# Configuration
LOG_DIR="logs"
PID_FILE="nginx.pid"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

RED='\033[0;31m'
GREEN='\033[0;32m'
BRIGHT='\033[1m'
NC='\033[0m'

# Makesure Nginx is running
if [ ! -f "$PID_FILE" ]; then
    echo "${RED}${BRIGHT}[Error]: Nginx PID file not found. Is Nginx running? Please Check once..${NC}"
    exit 1
fi

echo "Rotating logs..."

# Rename current logs
[ -f "$LOG_DIR/access.log" ] && mv "$LOG_DIR/access.log" "$LOG_DIR/access.log.$TIMESTAMP"
[ -f "$LOG_DIR/error.log" ] && mv "$LOG_DIR/error.log" "$LOG_DIR/error.log.$TIMESTAMP"

# Send USR1 signal to Nginx master process to re-open log files
kill -USR1 $(cat $PID_FILE)

echo "${GREEN}[Logs]: Logs rotated successfully.${NC}"
echo "${GREEN}[Updated]: New logs started. Old logs archived with timestamp $TIMESTAMP."
