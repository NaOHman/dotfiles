#!/bin/bash
source $(dirname $0)/config.sh
UPDATE_ICON="%{F$PAC_COL}pac%{F-}"

while [ 1 ] ; do
    UPDATES_COUNT=$(checkupdates | wc -l)
    if ((UPDATES_COUNT)); then
        echo "P $UPDATE_ICON $UPDATES_COUNT"
    else
        echo "P" 
    fi
    sleep $UPDATE_TIME
done
