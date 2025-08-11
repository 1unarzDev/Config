#!/bin/bash

# Config
WALLPAPER_DIR="$HOME/.config/swww/wallpapers"
ROFI_THEME="$HOME/.config/rofi/config-wallpaper.rasi"

# Check if rofi is already running
if pidof rofi >/dev/null; then
  pkill rofi
fi

# Display details
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale')
monitor_height=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .height')

# Icons
icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc)
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

# Retrieve wallpapers (both images & videos)
mapfile -d '' PICS < <(find -L "${WALLPAPER_DIR}" -type f \( \
  -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"

# Rofi command
rofi_command="rofi -i -show -dmenu -config $ROFI_THEME -theme-str $rofi_override"

# Sorting Wallpapers
menu() {
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))

  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"

  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    if [[ "$pic_name" =~ \.gif$ ]]; then
      cache_gif_image="$HOME/.cache/gif_preview/${pic_name}.png"
      if [[ ! -f "$cache_gif_image" ]]; then
        mkdir -p "$HOME/.cache/gif_preview"
        magick "$pic_path[0]" -resize 1920x1080 "$cache_gif_image"
      fi
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_gif_image"
    elif [[ "$pic_name" =~ \.(mp4|mkv|mov|webm|MP4|MKV|MOV|WEBM)$ ]]; then
      cache_preview_image="$HOME/.cache/video_preview/${pic_name}.png"
      if [[ ! -f "$cache_preview_image" ]]; then
        mkdir -p "$HOME/.cache/video_preview"
        ffmpeg -v error -y -i "$pic_path" -ss 00:00:01.000 -vframes 1 "$cache_preview_image"
      fi
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_preview_image"
    else
      printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
    fi
  done
}

choice=$(menu | $rofi_command)
choice=$(echo "$choice" | xargs)
RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)

if [[ -z "$choice" ]]; then
  echo "No choice selected. Exiting."
  exit 0
fi

# Handle random selection correctly
if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
  choice=$(basename "$RANDOM_PIC")
fi

choice_basename=$(basename "$choice" | sed 's/\(.*\)\.[^.]*$/\1/')

# Search for the selected file in the wallpapers directory, including subdirectories
selected_file=$(find "$WALLPAPER_DIR" -iname "$choice_basename.*" -print -quit)

if [[ -z "$selected_file" ]]; then
  echo "File not found. Selected choice: $choice"
  exit 1
fi

apply_image_wallpaper "$selected_file"
