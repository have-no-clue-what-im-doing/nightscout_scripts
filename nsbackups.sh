#!/bin/bash
# Check if share is mounted:
set -e
containers=(nightscout mongo traefik)
if mountpoint -q /mnt/nsbackups; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') nightscout backup share is mounted" >> nsbackups.log
        for container in "${containers[@]}"; do
                if docker ps -q -f name="$container" | grep -q .; then
                        echo "$(date '+%Y-%m-%d %H:%M:%S') $container is running" >> nsbackups.log
                else
                        echo "$(date '+%Y-%m-%d %H:%M:%S') $container is not running, exiting script" >> nsbackups.log
                        exit
                fi
        done
else
        echo "$(date '+%Y-%m-%d %H:%M:%S') nightscout backup share is not mounted, exiting script" >> nsbackups.log
        exit
fi
echo "$(date '+%Y-%m-%d %H:%M:%S') Share is mounted and containers are running, starting backup..." >> nsbackups.log
sudo docker exec mongo mongodump --out /data/backup
sudo docker exec mongo tar -czvf $(date +%F).tar.gz /data/backup
sudo docker cp mongo:/$(date +%F).tar.gz /mnt/nsbackups
docker exec mongo rm -rf /data/backup /$(date +%F).tar.gz
echo "$(date '+%Y-%m-%d %H:%M:%S') Backup created successfully" >> nsbackups.log
