#!/bin/sh

function rawregularlist {
  # creates a list of regular nodes from the markdown directory file
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
  # reates a list of validator nodes from the markdown directory file
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
  # outputs both lists
  rawregularlist
  rawvalidatorlist
}

function tojson {
  # converts a plain node list to a sorted json array, to be consumed by quorum
  tee | jq -R . | jq --indent 4 -s '.|unique'
}

function tostring {
  # converts a json array to a plain node list
  tee | sed 's/\[//g;s/\]//g;s/[[:blank:]]//g;s/\"//g;/^\s*$/d;s/\,//g;s/'\''//g'
}

function cutter {
  # given 2 numbers, it will split a json array into several pieces and then aggregate some of those pieces together again
  tee | jq "_nwise($2)" | jq -s . | jq ".[0:$1]|flatten"
}

function sliced {
  # creates partial permissioning files
  index=$(expr $1 + 1)
  rawvalidatorlist
  rawregularlist | tojson | cutter $index $2 | tostring
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

