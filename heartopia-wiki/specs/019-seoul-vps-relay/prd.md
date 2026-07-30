# PRD: Seoul VPS Relay

## 1. Summary

### Problem

Korean visitors to `heartopia-life.me` were intermittently routed to Cloudflare's LAX PoP, causing high latency and occasional 520 errors. The temporary ngrok Japan route is fast but has variable usage charges.

### Proposed Solution

Run a small Seoul Lightsail VPS as the public HTTPS relay. It forwards traffic over a WireGuard tunnel to the existing home Linux server, without exposing that server directly to the Internet.

### Success Criteria

- `heartopia-life.me` reaches the Seoul relay over HTTPS.
- The home server remains private; only WireGuard UDP is reachable between it and the VPS.
- Current traffic remains within the Lightsail $7/month plan's 2 TB monthly allowance.

## 2. Users And Use Cases

### Primary Users

- Korean visitors to Heartopia Wiki.
- Site operator maintaining the existing home server.

### User Stories

- As a Korean visitor, I want the site to use a nearby ingress so that pages load reliably without the LAX detour.
- As the operator, I want predictable hosting cost while retaining the existing app and database server.

## 3. Functional Scope

### In Scope

- Seoul Lightsail 1 GB Ubuntu relay.
- WireGuard tunnel between relay and current Linux server.
- TLS termination and reverse proxy at the relay.
- DNS cutover after direct and end-to-end verification.
- Keep Cloudflare Tunnel and ngrok available for rollback until verified.

### Out Of Scope

- Migrating the application or database to AWS.
- Changing application code.
- Replacing home Internet or router hardware.

## 4. Acceptance Criteria

- HTTPS requests to the production hostname return the existing site through the relay.
- The relay exposes only TCP 80/443 and WireGuard UDP; SSH access remains restricted to the Lightsail console/key.
- A WireGuard or origin failure has a documented rollback path to the existing ngrok route.

## 5. Constraints

- Tech: Ubuntu, WireGuard, Caddy reverse proxy, existing Docker/Nginx origin.
- Cost: $7/month Lightsail plan; avoid paid add-ons and automatic snapshots.
- External Dependencies: AWS Lightsail, DNS provider, home Internet.

## 6. Risks

- Home Wi-Fi outage: use wired Ethernet as soon as available; relay cannot serve when the home origin is offline.
- DNS/TLS cutover error: verify with a staging hostname and retain ngrok rollback.
- VPS compromise: use key-based access, firewall allowlist, and no direct home-origin exposure.

## 7. Open Questions

- None. The operator selected the Seoul 1 GB / $7 Lightsail relay and confirmed account billing.
