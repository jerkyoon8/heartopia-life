# Implementation Plan: Seoul VPS Relay

## Context

- Spec: `specs/019-seoul-vps-relay/spec.md`
- Current codebase notes:
  - Existing production origin serves Docker Nginx on local TCP 80.
  - Current root hostname is temporarily routed through ngrok; Cloudflare Tunnel remains available as fallback.
  - New Lightsail instance is Ubuntu, Seoul `ap-northeast-2`, 1 GB / 2 TB plan.

## Approach

1. Harden the relay baseline and install WireGuard/Caddy.
2. Create a two-peer WireGuard network: relay `10.88.0.1`, origin `10.88.0.2`.
3. Configure Caddy to reverse proxy only to `10.88.0.2:80` and obtain TLS after DNS points to the relay.
4. Verify tunnel and staging hostname, then switch production DNS from ngrok to the relay's public IPv4.
5. Monitor, retain rollback instructions, and later stop ngrok only after stability is confirmed.

## Impacted Files

- `specs/019-seoul-vps-relay/*.md`: change record and operator runbook.
- `/etc/wireguard/wg0.conf` on relay/origin: WireGuard peer configuration (not stored in repository).
- `/etc/caddy/Caddyfile` on relay: hostname-only reverse proxy configuration (not stored in repository).

## Data Model

- No application data change.

## API Or Interface Changes

- No application API change.
- Public ingress changes from ngrok to the Seoul relay after validation.

## Validation And Error Handling

- Check `wg show` on both hosts for a recent handshake and bidirectional ping.
- Curl the origin through the tunnel before exposing the hostname.
- Curl the hostname after TLS/DNS cutover and verify a 200 response and expected page content.
- If validation fails, restore the ngrok CNAME record before further diagnosis.

## Test Plan

- Manual: tunnel handshake, origin HTTP response, staging HTTPS response, production HTTPS response.
- Manual: confirm Lightsail firewall only has required ports.
- Manual: browser test map API and image assets after cutover.

## Risks And Mitigations

- DNS propagation/certificate delay: stage first, preserve ngrok record for rollback.
- Wi-Fi instability at origin: move origin to Ethernet; monitor WireGuard handshakes.
- $7 bundle overage: check Lightsail metrics monthly; current estimate is about 100 GiB/month versus 2 TB included.

## Alternatives Considered

- Continue ngrok: fast but request and transfer usage can create variable charges.
- Upgrade Cloudflare plan: may alter routing but no guarantee for Korean ISP peering.
- Direct port forwarding to home origin: rejected because it exposes the home service and router to the Internet.

## Plan Checklist

- [x] Spec의 모든 요구사항이 구현 접근에 매핑되어 있다.
- [x] 영향 파일이 구체적이다.
- [x] 테스트 방법이 있다.
- [x] 과설계 가능성이 검토되었다.
- [x] 미확정 사항이 남아 있으면 구현 전에 확인하도록 표시되어 있다.
