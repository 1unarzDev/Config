#!/bin/bash

# Config
WALLPAPER_DIR="$HOME/.config/swww/wallpapers"
ROFI_THEME="$HOME/.config/rofi/config-wallpaper.rasi"
CACHE_DIR="$HOME/.cache/wallpaper_thumbnails"
WAL_SCRIPT="$HOME/.config/scripts/wal.sh"

# Check if rofi is already running
if pidof rofi >/dev/null; then
  pkill rofi
  exit
fi

# Create cache directory
mkdir -p "$CACHE_DIR"

# Display details
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale')
monitor_height=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .height')

# Icons
icon_size=$(echo "scale=1; ($monitor_height * 10) / ($scale_factor * 150)" | bc)
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

# Retrieve wallpapers (both images & videos)
mapfile -d '' PICS < <(find -L "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0)

create_thumbnail() {
    local source_image="$1"
    local thumbnail_path="$2"
    
    # Skip if thumbnail already exists and is newer than source
    if [[ -f "$thumbnail_path" && "$thumbnail_path" -nt "$source_image" ]]; then
        return 0
    fi
    
    magick "$source_image" \
        -resize 600x400^ \
        -gravity center \
        -extent 600x400 \
        -unsharp 0x0.75+0.75+0.008 \
        -quality 100 \
        "$thumbnail_path" 2>/dev/null
}

# Sorting Wallpapers
menu() {
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))

    for pic_path in "${sorted_options[@]}"; do
        [[ -z "$pic_path" ]] && continue
        
        pic_name=$(basename "$pic_path")
        display_name=$(echo "$pic_name" | cut -d. -f1)
        
        safe_name=$(echo "$pic_name" | sed 's/[^a-zA-Z0-9._-]/_/g')
        thumbnail_path="$CACHE_DIR/${safe_name}.thumb.png"
        
        create_thumbnail "$pic_path" "$thumbnail_path"
        
        if [[ -f "$thumbnail_path" ]]; then
            printf "%s\x00icon\x1f%s\n" "$display_name" "$thumbnail_path"
        else
            printf "%s\x00icon\x1f%s\n" "$display_name" "$pic_path"
        fi
    done
}

choice=$(menu | rofi -i -show -show-icons -dmenu -p '' -config $ROFI_THEME -theme-str $rofi_override)
choice=$(echo "$choice" | xargs)

if [[ -z "$choice" ]]; then
  echo "No choice selected. Exiting."
  exit 0
fi

choice_basename=$(basename "$choice" | sed 's/\(.*\)\.[^.]*$/\1/')

# Search for the selected file in the wallpapers directory, including subdirectories
selected_file=$(find "$WALLPAPER_DIR" -iname "$choice_basename.*" -print -quit)

if [[ -z "$selected_file" ]]; then
  echo "File not found. Selected choice: $choice"
  exit 1
fi

$WAL_SCRIPT "$selected_file"
