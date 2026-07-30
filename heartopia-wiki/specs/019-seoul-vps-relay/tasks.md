# Tasks: Seoul VPS Relay

## Phase 1: Setup

- [x] T001 Configure relay packages, Lightsail firewall, and UFW.
  Files: `/etc/wireguard/wg0.conf`, `/etc/caddy/Caddyfile`
  Verify: Lightsail and UFW permit SSH, TCP 80/443, WireGuard UDP, and authenticated `wg0` traffic; Caddy and WireGuard are active.

- [x] T002 Configure WireGuard peer on the existing origin.
  Files: `/etc/wireguard/wg0.conf`
  Verify: `wg show` reports a recent peer handshake and bidirectional transfer.

## Phase 2: Verification

- [x] T003 Verify relay-to-origin HTTP over WireGuard before DNS change.
  Files: none
  Verify: relay `curl http://10.88.0.2/wiki` returned HTTP 200 in about 84 ms.

- [x] T004 Configure and test staging hostname and relay TLS.
  Files: `/etc/caddy/Caddyfile`, DNS record
  Verify: staging HTTPS returned HTTP 200 in about 91 ms; an external Korean visitor reported a very fast page load.

## Phase 3: Cutover

- [x] T005 Change root production DNS to the Seoul relay after staging passes.
  Files: DNS record
  Verify: root A record points to attached static IP `3.37.142.159` with DNS-only mode; `https://heartopia-life.me/wiki` returns 200 through relay.

- [x] T006 Test public pages, map APIs, images, and authenticated login callback.
  Files: none
  Verify: main/API/image requests returned 200, Google login returned 302 with the production callback, and `www` redirects to the root hostname.

## Phase 4: Polish

- [ ] T007 Observe traffic for 24 hours, retain ngrok rollback, then decide whether to stop ngrok.
  Files: ngrok systemd unit and DNS record only after confirmation
  Verify: no relay errors and acceptable Lightsail transfer trend.

## Completion Notes

- Tests run: WireGuard handshake and transfer, tunnel ping (0% loss, ~13 ms average), origin HTTP 200, staging and production TLS, main/API/image HTTP 200, Google OAuth redirect 302, `www` redirect, external visitor browser check.
- Known risks: the home origin still depends on its physical power and network.
- Follow-up: connect the home origin by Ethernet and configure an AWS budget alert.
