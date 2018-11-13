cat ../../CORE_VALIDATORS.md | \
gawk -F"|" \
'$3 { \
    match($3, / ([0-9.])* /, arr); \
    gsub(/^ +| +$/,"", arr[0]); \
    if (arr[0] != "") { \
        print "\n"$3"- https://"arr[0]":8443/v1/node/stop"; \
        system("curl -ss -k -X GET --cert ~/certs/monitor-client.crt  --key ~/certs/monitor-client.key --cacert ~/certs/alastria-ca.crt -m 3 -H \"accept: application/json\" https://"arr[0]":8443/v1/node/stop"); \
    } \
}'

cat ../../CORE_VALIDATORS.md | \
gawk -F"|" \
'$3 { \
    match($3, / ([0-9.])* /, arr); \
    gsub(/^ +| +$/,"", arr[0]); \
    if (arr[0] != "") { \
        print "\n"$3"- https://"arr[0]":8443/v1/node/update"; \
        system("curl -ss -k -X GET --cert ~/certs/monitor-client.crt  --key ~/certs/monitor-client.key --cacert ~/certs/alastria-ca.crt -m 10 -H \"accept: application/json\" https://"arr[0]":8443/v1/node/update"); \
    } \
}'