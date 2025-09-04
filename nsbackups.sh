#!/bin/bash

MOUNT_POINT="/mnt/nsbackups"
LOG_FILE="/home/nightscout/nsbackups.log"

set -e
containers=(nightscout mongo traefik)

if mountpoint -q "$MOUNT_POINT"; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') nightscout backup share is mounted" >> "$LOG_FILE"
        for container in "${containers[@]}"; do
                if docker ps -q -f name="$container" | grep -q .; then
                        echo "$(date '+%Y-%m-%d %H:%M:%S') $container is running" >> "$LOG_FILE"
                else
                        echo "$(date '+%Y-%m-%d %H:%M:%S') $container is not running, exiting script" >> "$LOG_FILE"
                        exit 1
                fi
        done
else
        echo "$(date '+%Y-%m-%d %H:%M:%S') nightscout backup share is not mounted, exiting script" >> "$LOG_FILE"
        exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') Share is mounted and containers are running, starting backup..." >> "$LOG_FILE"

# Create backup
sudo docker exec mongo mongodump --out /data/backup
sudo docker exec mongo tar -czvf $(date +%F).tar.gz /data/backup
sudo docker cp mongo:/$(date +%F).tar.gz "$MOUNT_POINT"
docker exec mongo rm -rf /data/backup /$(date +%F).tar.gz

echo "$(date '+%Y-%m-%d %H:%M:%S') Backup created successfully" >> "$LOG_FILE"
