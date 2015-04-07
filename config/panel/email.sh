#!/bin/bash

source $(dirname $0)/config.sh
EMAIL_ICON="^i($IPATH/mail1.xbm)"

while [ 1 ] ; do
    EMAIL_COUNT=$(curl -su $UNAME:$PASS https://mail.google.com/mail/feed/atom | grep fullcount | sed 's/.*<fullcount>\([0-9]*\)<.*/\1/')
    if ((EMAIL_COUNT > 0)); then
        echo "M %{F$EMAIL_COL}emails%{F-} $EMAIL_COUNT"
    else
        echo "M"
    fi
    sleep $EMAIL_TIME
done
