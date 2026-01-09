#!/usr/bin/env bash
max_iterations=1500
count=0

wait_for_app() {
  local app_class="$1"
  local app_name="$2"

  local count=0
  while true; do
    if hyprctl clients | grep -q "class: $app_class"; then 
      break
    fi

    count=$((count + 1))
    if [ $count -ge $max_iterations ]; then
      echo "Timeout: $app_name not found after 2.5 minutes"
      exit 1
    fi

    sleep 0.1
  done
}

wait_for_app "spotify" "Spotify"
hyprctl dispatch togglespecialworkspace spotify

wait_for_app "obsidian" "Obsidian"
hyprctl dispatch togglespecialworkspace notes

wait_for_app "BeeperTexts" "Beeper"
hyprctl dispatch togglespecialworkspace notes
