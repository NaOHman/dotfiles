xrdb ~/.Xresources 

wmname LG3D
xsetroot -cursor_name left_ptr &
hsetroot -fill /home/jeffrey/Pictures/Wallpaper/flower.jpg &
unclutter -grab -noevents -root &
# compton --config /home/jeffrey/.config/compton/compton.conf &
urxvtd &
syndaemon -t -k -i 2 -d &
#redshift &

#.config/bspwm/panel/panel &
mkfifo $PANEL_FIFO &
#sxhkd &
.config/panel/panel &
exec xmonad 

