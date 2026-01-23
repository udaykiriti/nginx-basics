# Setup & Usage Guide

## Prerequisites
- **Linux/Mac OS** [Windows requires WSL]
- **Nginx** installed [`sudo <pckg-mgr-name> install nginx` or `brew install nginx`]
- **Python 3**
- **Docker** [Optional]

## Local Installation
The project is self-contained.

### Starting the Server
Run the manager script from the project root:
```bash
./scripts/manage.sh start
```

**Access the system at:**
- Frontend: https://localhost:8080/index.html
- API Status: https://localhost:8443/status
This will:
1.  Stop any existing instances [fresh start].
2.  Start two Python backend servers.
3.  Start Nginx.

### Stopping the Server
```bash
./scripts/manage.sh stop
```

### Reloading Configuration
If you change `nginx.conf`, apply changes instantly:
```bash
./scripts/manage.sh reload
```

## Docker Installation
If you prefer containers, you can build the image:
```bash
docker-compose -f docker/docker-compose.yml up --build
```
This starts the entire stack listening on port 8080.

## SSL/TLS Setup
To enable HTTPS, generate self-signed certificates:
```bash
./scripts/generate-certs.sh
```
This creates `certs/` and enables port **8443**.

## Troubleshooting

### "Address already in use"
This means Nginx or Python is already running.
**Fix:** Run `./scripts/manage.sh restart` to force a cleanup.

### "Permission denied" (logs)
This happens if you run Nginx as root once and then as a user.
**Fix:** `sudo rm -rf logs/*` and try again.

### "nginx: command not found"
Nginx is not installed or not in your PATH.
**Fix:** `sudo <pckg-mgr-name> install nginx`.
