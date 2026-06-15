#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# Configurations
BACKUP_SRC="/"
BACKUP_DST="/var/backups/ssd"
EXCLUDE_FILE="/opt/server-ops/system/backup-exclude.txt"
DATETIME=$(date +%Y-%m-%d_%H%M%S)
LATEST_LINK="${BACKUP_DST}/latest"

# Ensure backup destination directory exists
mkdir -p "${BACKUP_DST}"

# Check for previous backup to use as link destination
RSYNC_OPTS="-aAXv --delete --numeric-ids"
if [ -L "${LATEST_LINK}" ]; then
    RSYNC_OPTS="${RSYNC_OPTS} --link-dest=$(readlink -f "${LATEST_LINK}")"
fi

# Run the backup
echo "Starting backup at $(date)"
rsync ${RSYNC_OPTS} \
      --exclude-from="${EXCLUDE_FILE}" \
      "${BACKUP_SRC}" \
      "${BACKUP_DST}/backup-${DATETIME}"

# Update the latest symlink
rm -f "${LATEST_LINK}"
ln -s "backup-${DATETIME}" "${LATEST_LINK}"

# Retention policy: keep the last 14 backups
echo "Cleaning up old backups..."
cd "${BACKUP_DST}"
# List directories starting with 'backup-' sorted by modification time, skip the most recent 14, and delete the rest
ls -dt backup-* | tail -n +15 | xargs -r rm -rf

echo "Backup completed successfully at $(date)"
