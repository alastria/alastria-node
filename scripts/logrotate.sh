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
    # postrotate
    #     find /home/$USER/alastria/logs/ -type f -empty -exec rm -rf {} \;
    # endscript
}" > /home/$USER/alastria/data/alastria-logrotate.conf


# Setting logrotate every 24h
# we could add a new variable to let set logrotate date moment.
# if DATE == SETDATE then logrotate.
# logrotate is set to 01:01 AM

while true
 do
    DATE=$(date +%H%M)
  if [ $DATE == "0101" ]
  then
  /usr/sbin/logrotate ~/alastria/data/alastria-logrotate.conf --state ~/alastria/logs/alastria_logrotate.state --verbose --force
  fi

sleep 59
done

set +u
set +e
