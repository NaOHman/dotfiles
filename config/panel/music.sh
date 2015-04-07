#!/bin/bash

source $(dirname $0)/config.sh

function get_music {
    SPOT_STAT=$(spotwrap isPlaying)
    MPD_STAT=$(mpc status 2>/dev/null | grep 'playing' 2>/dev/null)
    if [[ $SPOT_STAT == "Spotify Down" ]] ; then
        MUSIC_PLAYING=$(mpc current)
        if [[ MPD_STAT == "" ]] ; then
            MUSIC_STAT="Paused"
        else
            MUSIC_STAT="Playing"
        fi
    else
        MUSIC_STAT="Playing"
        MUSIC_PLAYING=$(spotwrap)
        if [[ $SPOT_STAT == "Paused" && $MPD_STAT != "" ]] ; then
            MUSIC_PLAYING=$(mpc current)
            MUSIC_STAT="Playing"
        fi
    fi
}

if [[ $1 -eq "kick" ]] ; then
    get_music
    echo "S$MUSIC_PLAYING" > $PANEL_FIFO
else 
    while [ 1 ] ; do
        get_music
        echo "S$MUSIC_PLAYING"
        sleep $SLEEP_TIME
    done
fi
