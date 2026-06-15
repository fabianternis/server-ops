# Server Operations Monorepo

Centralized execution repository for headless node automation, network routing, and state management.

## Architectural Deployment

1. Clone the repository to the target node.
2. Duplicate `config.cfg.example` to `config.cfg` and populate the systemic variables.
3. Apply execution permissions to all operational scripts:
   `chmod +x network/*.sh system/*.sh deployment/*.sh`

## Directory Matrix

### `/network/`
* `captive-login.sh`: Verifies outbound WAN availability and executes a headless `curl` POST request to satisfy local gateway interception parameters.
* `wg-keepalive.sh`: Monitors the cryptographic tunnel state. Restarts the local interface via `systemctl` upon detecting persistent packet loss to the target peer. *Requires root execution.*

### `/system/`
*(Awaiting script allocation)*

### `/deployment/`
*(Awaiting script allocation)*

## Automation Protocol

Integration with the `cron` daemon is required for automated state verification.

**Example Crontab Configuration:**
```cron
# Execute captive portal validation every 5 minutes
*/5 * * * * /path/to/server-ops/network/captive-login.sh

# Execute WireGuard diagnostic every 2 minutes (Requires Root)
*/2 * * * * /path/to/server-ops/network/wg-keepalive.sh
