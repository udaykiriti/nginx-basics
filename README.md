# Nginx Learning Playground

A comprehensive local Nginx environment for learning and testing production-grade system design patterns.

## Quick Start

Run the management script from the project root:

```bash
# Start the entire stack (Nginx + All Backend Nodes)
./scripts/manage.sh start

# Stop the things..
./scripts/manage.sh stop

# Apply config changes without downtime
./scripts/manage.sh reload
```

**Access the Frontend Gateway:** https://localhost:8080/index.html

**Access the API Gateway:** https://localhost:8443/status

---

## Advanced Features

### Traffic Management
- **Blue/Green Deployment**: Instant switching between stable (Blue) and new (Green) environments.
- **A/B Testing**: Random 20% traffic splitting for experimental feature validation.
- **Dynamic Routing**: User-controlled environment selection via cookies or custom headers.
- **Tiered Rate Limiting**: Differentiated quotas for free and premium users (using X-Premium-Key).

### System Resilience
- **Active Caching**: Background cache updates (Stale-While-Revalidate) to ensure zero-latency for users during cache refreshes.
- **DoS Protection**: Strict timeouts and body size limits to prevent resource exhaustion attacks.
- **Health Monitoring**: Integrated health check endpoints and Nginx stub status metrics.

### Security and Observability
- **Secure Links**: Time-limited, token-based access protection for confidential files.
- **Infrastructure Hiding**: Stripping backend identifying headers (Server, X-Powered-By).
- **Request Tracing**: End-to-end observability using unique X-Request-ID headers.
- **Content Injection**: Automated footer injection for system-wide metadata display.

---

## Documentation
- All About docs/ : docs/README.md
- Architecture Overview: docs/architecture.md
- Feature Implementation: docs/features.md
- Setup Guide: docs/setup.md
- API Specification: docs/api.md

---

## Credentials
- Username: admin
- Password: secret
- Premium Key: premium-secret
