#!/bin/bash

source $(dirname $0)/config.sh

cnt="0"
while [ 1 ] ; do
    if ((cnt % 30 == 0)); then
        email=$($ROOT_DIR/email.sh)
        updates=$($ROOT_DIR/pacman.sh)
        weather=$($ROOT_DIR/weather.sh)
    fi
    volume=$($ROOT_DIR/volume.sh)
    battery=$($ROOT_DIR/battery.sh)
    wifi=$($ROOT_DIR/wifi.sh)
    date=$($ROOT_DIR/date.sh)
    music=$($ROOT_DIR/music.sh)
    let cnt++
    printf "%s\n" "S$date | $wifi | $battery | $updates | $volume | $email | $weather | $music" 
    sleep $SLEEP_TIME
done
