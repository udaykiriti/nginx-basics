#!/bin/bash

# Configuration
LOG_DIR="logs"
PID_FILE="nginx.pid"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Makesure Nginx is running
if [ ! -f "$PID_FILE" ]; then
    echo "Error: Nginx PID file not found. Is Nginx running?"
    exit 1
fi

echo "Rotating logs..."

# Rename current logs
[ -f "$LOG_DIR/access.log" ] && mv "$LOG_DIR/access.log" "$LOG_DIR/access.log.$TIMESTAMP"
[ -f "$LOG_DIR/error.log" ] && mv "$LOG_DIR/error.log" "$LOG_DIR/error.log.$TIMESTAMP"

# Send USR1 signal to Nginx master process to re-open log files
kill -USR1 $(cat $PID_FILE)

echo "Logs rotated successfully."
echo "New logs started. Old logs archived with timestamp $TIMESTAMP."
