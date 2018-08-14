#!/bin/sh
cat ../../DIRECTORY_VALIDATOR.md | \
gawk -F"|" \
'$5~/enode/ { \
     match($5, /enode:\/\/[0-9a-z]*@([.0-9]*):[0-9]+/, arr); \
     if (arr[1] != "")  { \
          print "\n"$2"- https://"arr[1]":8443/v1/node/update"; \
          system("curl -ss -k -X GET --cert ~/certs/monitor-client.crt  --key ~/certs/monitor-client.key --cacert ~/certs/alastria-ca.crt -m 3 -H \"accept: application/json\" https://"arr[1]":8443/v1/node/update")
     } \
}'
