HASKELL="--"
CSS="\/\*"
XML="<!--"
BASH="#"
VIM="\""

for i in {0..15}; do
    colors[$i]=$(grep -e "^[^!].*color$i:" $1 | sed -r "s/.*#([0-9a-fA-F]{6}).*/\1/")
done
colors[16]=$(grep -e "^[^!].*foreground:" $1 | sed -r "s/.*#([0-9a-fA-F]{6}).*/\1/")
colors[17]=$(grep -e "^[^!].*background:" $1 | sed -r "s/.*#([0-9a-fA-F]{6}).*/\1/")

function replace_in_file {
    for i in  {0..15}; do
        sed -ri "s/$PREFIX[0-9a-fA-F]{6}(.*$COMMENT\s*color$i)/$PREFIX${colors[i]}\1/" $FILE
    done
    sed -ri "s/$PREFIX[0-9a-fA-F]{6}(.*$COMMENT\s*colorFG)/$PREFIX${colors[16]}\1/" $FILE
    sed -ri "s/$PREFIX[0-9a-fA-F]{6}(.*$COMMENT\s*colorBG)/$PREFIX${colors[17]}\1/" $FILE
}

COMMENT=$VIM
PREFIX="#"
FILE="/home/jeffrey/.vimperator/colors/forest.vimp"
replace_in_file

COMMENT=$HASKELL
FILE="/home/jeffrey/.xmonad/xmonad.hs"
replace_in_file
xmonad --recompile

COMMENT=$CSS
FILE="/home/jeffrey/.mozilla/firefox/wnzaoc8u.default/chrome/userChrome.css"
replace_in_file

FILE="/home/jeffrey/.themes/MyNumix/gtk-3.0/gtk.css"
replace_in_file

FILE="/home/jeffrey/.themes/MyNumix/gtk-3.0/gtk-dark.css"
replace_in_file

FILE="/home/jeffrey/.themes/Intellij/gtk-3.0/gtk.css"
replace_in_file

FILE="/home/jeffrey/.themes/Intellij/gtk-3.0/gtk-dark.css"
replace_in_file

COMMENT=$BASH
FILE="/home/jeffrey/.config/panel/config.sh"
replace_in_file

FILE="/home/jeffrey/.themes/MyNumix/gtk-2.0/gtk2hack.sh"
replace_in_file
/home/jeffrey/.themes/MyNumix/gtk-2.0/gtk2hack.sh

FILE="/home/jeffrey/.themes/Intellij/gtk-2.0/gtk2hack.sh"
replace_in_file
/home/jeffrey/.themes/Intellij/gtk-2.0/gtk2hack.sh

COMMENT=$XML
FILE=/home/jeffrey/.themes/MyNumix/metacity-1/metacity-theme-3.xml
replace_in_file

PREFIX=""
FILE=/home/jeffrey/.AndroidStudio/config/colors/MyColors/colors/MyColors.xml
replace_in_file
/home/jeffrey/.AndroidStudio/config/colors/makeColors.sh

sed -i "s|/home/jeffrey/.colors/[^\"]+|$1|" /home/jeffrey/.Xresources
xrdb /home/jeffrey/.Xresources
