./tools/xrandr-mbpr
#ibus-daemon -x &
#ibus restart
./tools/rate
#echo Xft.dpi: 180 | xrdb -merge
xrdb -merge ~/.Xresources
exec i3
