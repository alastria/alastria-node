#!/bin/bash
set -u
set -e

USER=$(whoami)
echo "
/home/$USER/alastria/logs/quorum.log /home/$USER/alastria/logs/constellation.log {
    rotate 7
    daily
    copytruncate
    compress
    delaycompress
    missingok
    notifempty
    postrotate
        find /home/$USER/alastria/logs/ -type f -empty -exec rm -rf {} \;
    endscript
}" > /home/$USER/alastria/data/alastria-logrotate.conf
set +u
set +e
