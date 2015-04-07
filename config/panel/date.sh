#!/bin/bash

source $(dirname $0)/config.sh
TIME_ICON="%{F$TIME_COL}Time%{F-}"

while [ 1 ] ; do
    TIME_DATE=$(date +%R)
    echo "T $TIME_DATE"
    sleep $SLEEP_TIME
done
