#!/usr/bin/env bash

if pgrep -x "wlogout" >/dev/null; then
    pkill -x "wlogout"
    exit 0
fi

wLayout="$HOME/.config/wlogout/layout_1"
wlTmplt="$HOME/.config/wlogout/style_1.css"

# detect monitor res
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

# scale config layout and style
wlColms=5
export mgn=$((y_mon * 38 / hypr_scale))
export hvr=$((y_mon * 33 / hypr_scale))

# scale font size
export fntSize=$((y_mon * 2 / 100))

# detect wallpaper brightness
export BtnCol="white"

# eval hypr border radius
hypr_border="${hypr_border:-10}"
export active_rad=$((hypr_border * 5))
export button_rad=$((hypr_border * 3))

# get pywal colors
source "$HOME/.cache/wal/colors-wlogout.sh"

hex_to_rgba() {
    local hex="$1"
    local alpha="${2:-1.0}"
    
    local r=$((0x${hex:0:2}))
    local g=$((0x${hex:2:2}))
    local b=$((0x${hex:4:2}))
    
    echo "rgba($r, $g, $b, $alpha)"
}

export foreground=$(hex_to_rgba "$foreground" '0.7')
export background=$(hex_to_rgba "$background" '0.7')

for i in {0..15}; do
    color_var="color$i"
    export "color$i=$(hex_to_rgba "${!color_var}" '0.7')"
done

# eval config files
wlStyle="$(envsubst <"${wlTmplt}")"

# launch wlogout
wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --layout "${wLayout}" --css <(echo "${wlStyle}") --protocol layer-shell
