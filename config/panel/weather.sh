#!/bin/bash

source $(dirname $0)/config.sh
WEATHER_ICON="^i($IPATH/temp1.xbm)"

while [ 1 ] ; do
    WEATHER_DATA=$(curl "http://api.wunderground.com/weather/api/$WU_KEY/conditions/q/${WU_LOCATION}.xml")
    TEMP=$(echo $WEATHER_DATA | sed 's/.*<temp_f>\([^<]*\).*/\1°/')
    WEATHER=$(echo $WEATHER_DATA | sed 's/.*<weather>\([^<]*\).*/\1/')
    if [[ $WEATHER == "" ]]; then
        echo "F"
    else
        echo "F %{F$WEATHER_COL}$WEATHER%{F-} $TEMP"
    fi
    sleep $WEATHER_TIME
done
