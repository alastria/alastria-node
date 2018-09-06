#!/bin/bash
while true
do
CONTROL="TESTNET"
LOGFILE="$(ls -ltras ~/alastria/logs/quorum_2018* |tail -n 1 |awk {'print $10'})"
#ROUND0="$(grep -E "DEBUG\[$(date -u "+%m-%d|%H:%M")\]New Round" $LOGFILE |awk -F'\t' -v d=$DATETIME -v c=$CONTROL 'BEGIN{OFS=";";} {print d$1,c,$5,$5;}'| grep -E "old_round=0" | sort |uniq -c| sed -s 's/=/:/g')"
ROUND0=$(grep -E "DEBUG\[$(date -u "+%m-%d|%H:%M")\]New Round" $LOGFILE| awk 'BEGIN{OFS=";";}{print $5,$7}'|sed 's/=/":"/g'|sed 's/;/";"/g' |sed 's/$/"/g' |sed 's/^/";"/g'| sort |uniq -c | sed 's/[[:space:]]//g')

    if [ ! -z "$ROUND0" ]; then
        CATCH="{\"@timestamp\":\"`date -u "+%Y-%m-%dT%H:%M:%S"`\",\"catchup\":\"$ROUND0}"
        echo "$CATCH" 
    else
       awk 'BEGIN{printf " 0\told_round=0\told_proposer=null\n =====\n"}'
   fi
sleep 10
done
