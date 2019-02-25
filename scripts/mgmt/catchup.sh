#!/bin/bash
# Author: jacinto@seriousman.org
# script to catch old_round metrics in quorum logs
# message comes as show bellow
# {"@timestamp":"2018-09-06T11:58:40","catchup":"43121";"old_round":"0";"old_proposer":"0x228B0dCd6769Cf3257627D5F94731227381FdaFb"}
while true
do
CONTROL="TESTNET"
LOGFILE="$(ls -ltras ~/alastria/logs/quorum_2018* |tail -n 1 |awk {'print $10'})"
#ROUND0="$(grep -E "DEBUG\[$(date -u "+%m-%d|%H:%M")\]New Round" $LOGFILE |awk -F'\t' -v d=$DATETIME -v c=$CONTROL 'BEGIN{OFS=";";} {print d$1,c,$5,$5;}'| grep -E "old_round=0" | sort |uniq -c| sed -s 's/=/:/g')"
ROUND0=$(grep -E "DEBUG\[$(date -u "+%m-%d|%H:%M")\]New Round" $LOGFILE| awk 'BEGIN{OFS="\",\"";}{print $5,$7}'|sed 's/=/":"/g' |sed 's/$/"/g' |sed 's/^/","/g'| sort |uniq -c | sed 's/[[:space:]]//g')

    if [ ! -z "$ROUND0" ]; then
        CATCH="{\"@timestamp\":\"`date -u "+%Y-%m-%dT%H:%M:%S"`\",\"catchup\":\"$ROUND0}"
        echo "$CATCH" 
    else
       echo "{\"@timestamp\":\"`date -u "+%Y-%m-%dT%H:%M:%S"`\",\"catchup\": null,\"old_round\": null,\"old_proposer\":null}"
   fi
sleep 10
done
