#!/bin/sh

function rawregularlist {
  cat ../../DIRECTORY_REGULAR.md | \
  gawk -F"|" \
  '$6~/enode/ { \
     match($6, /enode:\/\/[0-9a-z]*@([.0-9]*):[0-9]+/, arr); \
     if (arr[1] != "")  { \
        print "\n"$6""; \
     } \
  }' | sed 's/[[:blank:]]//g;s/\"//g;/^\s*$/d'
}

function rawvalidatorlist {
  cat ../../DIRECTORY_VALIDATOR.md | \
  gawk -F"|" \
  '$5~/enode/ { \
       match($5, /enode:\/\/[0-9a-z]*@([.0-9]*):[0-9]+/, arr); \
       if (arr[1] != "")  { \
            print "\n"$5""; \
       } \
  }' | sed 's/[[:blank:]]//g;s/\"//g;/^\s*$/d'
}

function rawcombinedlist {
  rawregularlist
  rawvalidatorlist
}

function tojson {
  
  tee | jq -R . | jq --indent 4 -s '.|unique'
}

function sliced {
  index=$(expr $1 + 1)
  rawvalidatorlist
  rawregularlist | tojson | jq "_nwise($2)" | jq -s . | jq ".[1:$index]|flatten" | sed 's/\[//g;s/\]//g;s/[[:blank:]]//g;s/\"//g;/^\s*$/d'
  
}

case "$1" in 
  --regular)
  rawregularlist | tojson
  ;;
  --validator)
  rawvalidatorlist | tojson
  ;;
  --combined)
  rawcombinedlist | tojson
  ;;
  --sliced)
  sliced $2 $3 | tojson
  ;;
esac

