#!/usr/bin/env bash
max_iterations=1500
count=0

while true; do
  if hyprctl clients | grep -q "class: Spotify"; then 
    break
  fi
  
  count=$((count + 1))
  if [ $count -ge $max_iterations ]; then
    echo "Timeout: Spotify not found after 2.5 minutes"
    exit 1
  fi
  
  sleep 0.1
done

hyprctl dispatch togglespecialworkspace spotify
