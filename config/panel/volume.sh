#!/bin/bash
source $(dirname $0)/config.sh

function get_volume {
   VOL_PERC=$(amixer get Master | grep '%' | awk '{gsub(/[\[\]%]/,""); print $4}')
   VOL_STAT=$(amixer get Master | grep '%' | awk '{gsub(/[\[\]]/,""); print $6}')
   if [ $VOL_STAT == "on" ] ; then
       VOL_ICON="%{F$VOL_COL}vol%{F-}"
   else
       VOL_ICON="%{F$VOL_COL}mute%{F-}"
   fi
}

if [[ $1 -eq "kick" ]] ; then
    get_volume
    echo "V $VOL_ICON $VOL_PERC " > $PANEL_FIFO
else
    while [ 1 ] ; do
        get_volume
        echo "V $VOL_ICON $VOL_PERC "
        sleep $SLEEP_TIME
    done
fi
