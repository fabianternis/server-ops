# Instructions for Future Gemini/AI Agents

Welcome, Agent. This system is a headless Ubuntu Server mini-PC configured for automated system state management, network routing, and backups.

## System Architecture

1. **Automation Repository:** All operational scripts, network helpers, and configurations are located in the [server-ops](file:///opt/server-ops) repository.
2. **Backups:** The system has a daily versioned backup cron job configured using `rsync --link-dest` at `/opt/server-ops/system/backup-ssd.sh`. Snapshots are stored under `/var/backups/ssd`.
3. **Captive Portal:** The node checks outbound internet health every 5 minutes using `captive-login.sh` and automatically signs in using credentials located in `config.cfg`.
4. **WireGuard VPN:** The WireGuard link stability is checked every 2 minutes by `wg-keepalive.sh`. If the VPN peer goes down while the host's general internet remains active, the script restarts the `wg-quick@wg0` service.

## Operations Protocols

### Sudo & Root Privileges
If you do not have passwordless sudo, you can run elevated host commands using the pre-configured LXD container `alpine-root`:
* The host filesystem is mounted inside the container at `/mnt/host`.
* You can execute commands as root in a host chroot via:
  `lxc exec alpine-root -- chroot /mnt/host <your_command>`

### Git Commit Guidelines
When pushing commits to the `server-ops` repository, you MUST use the following git config settings:
* **User Name:** `xpsystems agent`
* **User Email:** `ai-agent@xpsystems.eu`

Ensure you never commit the local `config.cfg` file, as it contains sensitive credentials. It is already excluded in `.gitignore`.

### Key Configuration Files
* **Local Credentials & Gateway:** [config.cfg](file:///opt/server-ops/config.cfg)
* **Exclude list for backups:** [backup-exclude.txt](file:///opt/server-ops/system/backup-exclude.txt)
* **System-wide Cron Configuration:** [server-ops](file:///etc/cron.d/server-ops)
