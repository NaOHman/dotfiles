#!/bin/bash
source $(dirname $0)/config.sh

while [ 1 ] ; do
    WIFI_QUAL="4*$(iwconfig $WIFI_DEV | grep "Link Quality"  | awk '{gsub(/=/," "); print $3}')"
    WIFI_SPEED=$(iwconfig $WIFI_DEV | grep "Bit Rate" | awk '{gsub(/=/," "); print $3}') 
    if [[ $WIFI_QUAL == "4*" ]]; then
        WIFI_ICON="%{F$WIFI_COL}wifi%{F-}"
        WIFI_SPEED=0
    else
        WIFI_ICON="%{F$WIFI_COL}wifi%{F-}"
    fi
    echo "I $WIFI_ICON $WIFI_SPEED"
    sleep $SLEEP_TIME
done
