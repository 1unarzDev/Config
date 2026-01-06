if pgrep waybar > /dev/null; then
  killall -9 waybar
else
  waybar &
fi
