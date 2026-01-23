# Nginx Features Explained

This project demonstrates advanced Nginx capabilities used in enterprise-level system design.

## 1. Blue/Green Deployment
- **Concept**: Maintaining two identical production environments to allow instant switching and zero-downtime updates.
- **Implementation**: Uses a 'map' to route traffic to 'backend blue' or 'backend green' based on the X-Target-Env header.

## 2. Secure Link Protection
- **Concept**: Restricting access to sensitive files using hash-based tokens and expiration timestamps.
- **Implementation**: Uses the 'secure link' module with a secret key. Access is denied (403) without a valid 'st' and 'e' parameter.

## 3. Tiered Rate Limiting
- **Concept**: Providing different Quality of Service (QoS) levels based on user identity.
- **Implementation**: Bypasses the standard 1r/s limit if a valid X-Premium-Key is provided.

## 4. Active Resilience (Stale-While-Revalidate)
- **Concept**: Serving expired cache content instantly while updating the cache in the background.
- **Implementation**: Uses 'proxy cache background update' and 'proxy cache use stale'.

## 5. Latency Observability
- **Concept**: Measuring how long the backend takes to respond vs the total time the user waited.
- **Implementation**: Captures '$upstream response time' and '$request time' in the extended log format and headers.

## 6. Content Injection (Sub-filter)
- **Concept**: Modifying the HTML response body on the fly to add global components.
- **Implementation**: Injects a system footer containing the Request ID and Hostname into all served HTML pages.

## 7. Infrastructure Hiding
- **Concept**: Removing technology-specific headers to prevent system fingerprinting.
- **Implementation**: Uses 'proxy hide header' to remove 'Server' and 'X-Powered-By' headers from backend responses.

## 8. Multi-Gateway Architecture
- **Concept**: Isolation of the static UI (Port 8080) from the API Logic (Port 8443).

## 9. Request Tracing
- **Concept**: Distributed tracing using a unique X-Request-ID for every transaction.
