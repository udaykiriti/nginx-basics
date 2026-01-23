# API Documentation

## Endpoint: `/api`

The API is a simple echo service provided by the Python backend scripts.

### Authentication
- **Type**: Basic Auth
- **Username**: `admin`
- **Password**: `secret`

### Request
`GET /api`

### Response
- **Status**: 200 OK
- **Body**: Plain text indicating which backend handled the request.
  - v1 response: "Hello from the Backend Application..."
  - v2 response: "Hello from API v2 (EXPERIMENTAL)..."
- **Headers**: 
  - X-API-Version: set to "v2-experimental" when served by the v2 backend.
  - X-Environment: "blue" or "green" depending on the active deployment.
  - X-Response-Time: The time in seconds taken by the backend to process the request.
  - X-Cache-Status: HIT, MISS, STALE, or EXPIRED.
  - X-Request-ID: Unique trace ID.

### Traffic Splitting (A/B Testing)
The API Gateway automatically routes 20% of requests to the v2 backend. This is determined by the `X-Request-ID` to ensure a consistent experience for a single request.

### Errors
- **401 Unauthorized**: If credentials are missing/wrong.
- **503 Service Unavailable**: If rate limit (1 req/sec) is exceeded.
