#!/bin/bash
set -u
set -e

USER=$(whoami)

# echo "Creating logrotate config file ..."
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


# Setting logrotate every 24h
while true
 do
sleep 86400
  # echo "rotating logs"
  /usr/sbin/logrotate ~/alastria/data/alastria-logrotate.conf --state ~/alastria/logs/alastria_logrotate.state --verbose --force
  # echo "" >> /home/$USER/alastria/logs/quroum.log
  # echo "done."
done

set +u
set +e
