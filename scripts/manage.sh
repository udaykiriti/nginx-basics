#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' 

echo -e "${GREEN}"
echo " _   _  _____ _____ _   _ __   __"
echo "| \ | ||  __ \_   _| \ | |\ \ / /"
echo "|  \| || |  \/ | | |  \| | \ V / "
echo "| . \` || | __  | | | . \` | /   \ "
echo "| |\  || |\_\ \_| |_| |\  |/ /^\ \ "
echo "\_| \_|\____/\___/\_| \_\/   \/ "
echo -e "${NC}"
echo -e "${BLUE}=== NGINX PLAYGROUND MANAGER ===${NC}"
echo ""

# Ensure we are in the Project Root
# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# cd ..
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

function _stop {
    echo -e "${RED}[-] Stopping Nginx and Backends...${NC}"
    if [ -f nginx.pid ]; then
        kill $(cat nginx.pid) 2>/dev/null
        rm -f nginx.pid
    else
        pkill -f "nginx -p" 2>/dev/null
    fi
    pkill -f "backend.py" 2>/dev/null
    pkill -f "backend-v2.py" 2>/dev/null
    pkill -f "backend-green.py" 2>/dev/null
    sleep 1
    echo "Services stopped."
}

function _start {
    # Stop first to start a clean version.
    _stop

    echo -e "${GREEN}[+] Starting Python Backends (Blue/Green/V2)...${NC}"
    mkdir -p logs
    nohup python3 scripts/backend.py 8081 > logs/backend1.log 2>&1 &
    nohup python3 scripts/backend.py 8082 > logs/backend2.log 2>&1 &
    nohup python3 scripts/backend-v2.py 8083 > logs/backend-v2.log 2>&1 &
    nohup python3 scripts/backend-green.py 8084 > logs/backend-green.log 2>&1 &

    sleep 1

    echo -e "${GREEN}[+] Starting Nginx...${NC}"

    if ! command -v nginx &> /dev/null; then
         echo -e "${RED}Error: 'nginx' command not found. Please install Nginx.${NC}"
         exit 1
    fi

    nginx -p "$(pwd)/" -c "conf/nginx.conf" -e "logs/error.log"

    if [ $? -eq 0 ]; then
        echo -e "${BLUE}>>> System Online! <<<${NC}"
        echo -e "Dashboard: ${GREEN}https://localhost:8443/dashboard.html${NC}"
        echo -e "API:       ${GREEN}https://localhost:8443/api${NC}"
    else
        echo -e "${RED}Failed to start Nginx. Check logs/error.log${NC}"
    fi
}

function _reload {
    echo -e "${BLUE}[*] Reloading Nginx configuration...${NC}"
    if [ -f nginx.pid ]; then
        kill -HUP $(cat nginx.pid)
        echo "Configuration reloaded..."
    else
        echo -e "${RED}Error: Nginx is not running...${NC}"
    fi
}

case "$1" in
    start)
        _start
        ;;
    stop)
        _stop
        ;;
    restart)
        _start
        ;;
    reload)
        _reload
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|reload}"
        echo "Example: ./scripts/manage.sh start"
        exit 1
        ;;
esac
