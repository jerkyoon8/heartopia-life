# Feature Spec: Seoul VPS Relay

## Source

- PRD: `specs/019-seoul-vps-relay/prd.md`
- Principles: `specs/principles.md`

## User Scenarios

### Scenario 1: Normal visitor request

- Given the Seoul relay and the home origin tunnel are healthy
- When a visitor opens `https://heartopia-life.me/wiki`
- Then the relay terminates HTTPS and proxies the request over WireGuard to the existing Nginx origin.

### Scenario 2: Relay verification before cutover

- Given a staging hostname is pointed at the relay
- When the operator checks the staging URL
- Then it returns the same application response without exposing the origin public address.

### Scenario 3: Failure rollback

- Given the relay path is unhealthy after DNS cutover
- When the operator restores the prior DNS record
- Then production can return to the ngrok endpoint without application redeployment.

## Functional Requirements

- FR-001: The relay must accept TCP 80 and 443 for the site hostname.
- FR-002: The relay must proxy application HTTP traffic only to the WireGuard address of the home origin.
- FR-003: WireGuard must authenticate peers with unique key pairs and use a private tunnel subnet.
- FR-004: The origin must accept proxy traffic from its WireGuard interface while retaining its current local Nginx service.
- FR-005: Production DNS must be changed only after end-to-end staging verification.

## Non-Functional Requirements

- NFR-001: The solution must fit the Lightsail 1 GB / $7 bundle under current traffic estimates.
- NFR-002: Sensitive keys must stay in server configuration files with restrictive permissions and never enter the repository.
- NFR-003: The public relay must not allow arbitrary proxying.

## Edge Cases

- Home server offline: reverse proxy returns a controlled 502; operator can roll DNS back to ngrok after restoring origin.
- WireGuard handshake failure: no traffic falls back to the home public IP.
- Certificate issuance failure: retain current ngrok DNS record and correct DNS/port access before cutover.

## Data Requirements

- No application database or schema changes.
- Store WireGuard private keys only on their respective hosts.

## Clarifications

- Q: Is the VPS replacing the home server?
  A: No. It is a relay; the existing server continues to run app, DB, and uploads.

## Review Checklist

- [x] 요구사항이 사용자 관점으로 설명되어 있다.
- [x] 성공 기준이 측정 가능하다.
- [x] 비목표가 명확하다.
- [x] 모호한 표현이 Assumptions 또는 Clarifications에 기록되어 있다.
- [x] 구현 방법이 과하게 먼저 정해지지 않았다.
