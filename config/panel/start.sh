#! /bin/bash
sleep 3
cd $(dirname $0)
bspc control --subscribe > $PANEL_FIFO &
./email.sh > $PANEL_FIFO &
./updates.sh > $PANEL_FIFO &
./weather.sh > $PANEL_FIFO &
./volume.sh > $PANEL_FIFO &
./battery.sh > $PANEL_FIFO &
./wifi.sh > $PANEL_FIFO &
./date.sh > $PANEL_FIFO &
./music.sh > $PANEL_FIFO &
