#!/bin/bash
source $(dirname $0)/config.sh

while [ 1 ] ; do 
    BAT_PERC=$(acpi -b | awk '{gsub(/%,/,""); print $4}' | sed "s/[^0-9]//g")
    BAT_STAT=$(acpi -b | awk '{gsub(/,/,""); print $3}')
    if [ $BAT_STAT == "Discharging" ]; then
        BAT_ICON="%{F$BAT_COL}bat%{F-}"
        if ((BAT_PERC <= 5)); then
            BAT_ICON="%{F$BAT_COL}bat%{F-}"
        fi
    else
        BAT_ICON="%{F$BAT_COL}char%{F-}"
    fi
    echo "B $BAT_ICON $BAT_PERC"
    sleep $SLEEP_TIME
done
