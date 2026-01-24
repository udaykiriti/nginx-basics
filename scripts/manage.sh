#!/bin/bash

#colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Reset
RESET='\033[0m'
NC='\033[0m'

# Styles
BOLD='\033[1m'
REVERSE='\033[7m'
HIDDEN='\033[8m'
BRIGHT='\033[1m'
DIM='\033[2m'
UNDERLINE='\033[4m'
BLINK='\033[5m'


echo -e "${GREEN}${BRIGHT}"
echo " _   _  _____ _____ _   _ __   __"
echo "| \ | ||  __ \_   _| \ | |\ \ / /"
echo "|  \| || |  \/ | | |  \| | \ V / "
echo "| . \` || | __  | | | . \` | /   \ "
echo "| |\  || |\_\ \_| |_| |\  |/ /^\ \ "
echo "\_| \_|\____/\___/\_| \_\/   \/ "
echo -e "${NC}"
echo -e "${BLUE} [NGINX PLAYGROUND]${NC}"
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

    # Kill backends via PID files
    for pid_file in logs/*.pid; do
        if [ -f "$pid_file" ]; then
            kill $(cat "$pid_file") 2>/dev/null
            rm -f "$pid_file"
        fi
    done

    sleep 1
    echo -e "${RED}[Stop]: Services stopped.${NC}"
}

function _start {
    # Stop first to start a clean version.
    _stop

    echo -e "${GREEN}[+] Starting Python Backends (Blue/Green/V2)...${NC}"
    mkdir -p logs
    
    nohup python3 scripts/backend.py 8081 > logs/backend1.log 2>&1 &
    echo $! > logs/backend1.pid

    nohup python3 scripts/backend.py 8082 > logs/backend2.log 2>&1 &
    echo $! > logs/backend2.pid

    nohup python3 scripts/backend-v2.py 8083 > logs/backend-v2.log 2>&1 &
    echo $! > logs/backend-v2.pid

    nohup python3 scripts/backend-green.py 8084 > logs/backend-green.log 2>&1 &
    echo $! > logs/backend-green.pid

    sleep 1

    echo -e "${GREEN}[+] Starting Nginx...${NC}"

    if ! command -v nginx &> /dev/null; then
         echo -e "${RED}[Error]: 'nginx' command not found. Please install Nginx.${NC}"
         exit 1
    fi

    nginx -p "$(pwd)/" -c "conf/nginx.conf" -e "logs/error.log"

    if [ $? -eq 0 ]; then
        echo -e "${BLUE}>>> [System Online!] <<<${NC}"
        echo -e "[Dashboard]: ${GREEN}https://localhost:8443/dashboard.html${NC}"
        echo -e "[API]:       ${GREEN}https://localhost:8443/api${NC}"
    else
        echo -e "${RED}${BRIGHT}[404]: Failed to start Nginx. Check logs/error.log${NC}"
    fi
}

function _reload {
    echo -e "${BLUE}[*] Reloading Nginx configuration...${NC}"
    if [ -f nginx.pid ]; then
        kill -HUP $(cat nginx.pid)
        echo "[Loading]: Configuration reloaded..."
        echo "[Wait]: Hold tight[{()}]"
    else
        echo -e "${RED}${BRIGHT}[Error]: Nginx is not running...${NC}"
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
        echo "[Usage]: $0 {start|stop|restart|reload}"
        echo "[Example]: ./scripts/manage.sh start"
        exit 1
        ;;
esac
