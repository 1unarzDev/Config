#!/bin/sh
WALLPAPER_DIR="$HOME/.config/swww/wallpapers"
STATE_FILE="$HOME/.cache/current_wallpaper"

# Get all images
images=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | sort)
total=$(echo "$images" | wc -l)

# Get current index
current=$(cat "$STATE_FILE" 2>/dev/null || echo "0")
next=$(( (current + 1) % total ))

# Get the image
image=$(echo "$images" | sed -n "$((next + 1))p")

# Set wallpaper with transition
swww img "$image" --transition-type fade --transition-duration 0.1

# Update colors
wal -i "$image"
source ~/.cache/wal/colors.sh
hyprctl keyword general:col.active_border "rgba(${color5#\#}ee) rgba(${color7#\#}ee) 45deg"
hyprctl keyword general:col.inactive_border "rgba(${color8#\#}aa)"
pkill waybar
waybar &

# Save current index
echo "$next" > "$STATE_FILE"
