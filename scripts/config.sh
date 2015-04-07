#!/bin/bash

WIFI_DEV="wlp2s0"
CITY="Saint Paul"
WU_KEY="7a07c8234eb31985"
WU_LOCATION="RU/Saint_Petersburg"
UNAME="jlyman@macalester.edu"
PASS="caligula"
SLEEP_TIME=2
WEATHER_TIME=600
UPDATE_TIME=600
EMAIL_TIME=600
ROOT_DIR="/home/jeffrey/.config/bspwm/panel"

BAR_GEO="1318x24+24+24"
BAR_UH="4"
BAR_BG="#FF${COLORBG:1}"
BAR_FG="#ff${COLORFG:1}"

TIME_COL="#ff${COLOR1:1}"
WIFI_COL="#ff${COLOR2:1}"
VOL_COL="#ff${COLOR3:1}"
BAT_COL="#ff${COLOR4:1}"
WEATHER_COL="#ff${COLOR5:1}"
PAC_COL="#ff${COLOR6:1}"
EMAIL_COL="#ff${COLOR7:1}"

ACTIVE="%{U#FF${COLOR2:1}}"
URGENT="%{U#ff${COLOR1:1}}"
OCCUPIED="%{U#FF${COLOR4:1}}"
INACTIVE="%{U#FF${COLORFG:1}}"

COLOR1="#9e8ba0" #color1
COLOR2="#e0d0c9" #color2
COLOR3="#e0dcd9" #color3
COLOR4="#1e39a0" #color4
COLOR5="#3745a0" #color5
COLOR6="#9a90a0" #color6
COLOR7="#6474a0" #color7
COLOR8="#6d83bf" #color8
COLOR9="#587ec8" #color9
COLOR10="#5775c8" #color10
COLOR11="#c7bac9" #color11
COLOR12="#354bc8" #color12
COLOR13="#9464c8" #color13
COLOR14="#8194c8" #color14
COLOR15="#a99ec8" #color15
COLORFG="#ffffff" #colorFG
COLORBG="#0e0e0e" #colorBG
