#!/bin/sh
cat DIRECTORY_VALIDATOR.md | \
gawk -F"|" \
'{ 
    if (!system("cat data/permissioned-nodes_validator.json | grep -q "$5)) {
        print $2
    } 
}'
