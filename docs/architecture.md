# Project Architecture

This project implements a **Hardened Multi-Gateway Architecture** with integrated resilience and deployment patterns.

## System Components

### Gateways
- **Frontend Gateway (8080)**: Optimized for static asset delivery, content injection, and secure link management.
- **API Gateway (8443)**: Centralized entry point for backend services, handling authentication, tiered rate limiting, and traffic splitting.

### Backend Environments
- **Blue Cluster**: The stable production environment (Ports 8081/8082).
- **Green Cluster**: The new/deployment environment (Port 8084).
- **Experimental Cluster**: The v2-canary environment (Port 8083).

## System Diagram
```
        [ Browser / Client ]
           |           |
    (Port 8080)    (Port 8443)
           |           |
     [ Frontend ]  [ API Gateway ]
     [ Gateway  ]  [ (Auth/CORS) ]
           |           |
    (Static Files)     +---> [ Traffic Manager ]
                               |           |
                       [ Deployment ] [ A/B Split ]
                       [ Blue/Green ] [   v1/v2   ]
```

## Observability Stack
The system tracks metrics through:
1. **Extended Access Logs**: RID, Cache Status, Request Time, and Upstream Response Time.
2. **Nginx Stub Status**: Real-time connection metrics.
3. **Response Headers**: X-Request-ID and X-Cache-Status returned to the client.