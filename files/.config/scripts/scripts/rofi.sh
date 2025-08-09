#!/bin/bash

# Start or close menu
if pgrep -x rofi > /dev/null; then
    pkill rofi
else
    # Put random kaomoji in placeholder text
    JSON_FILE=~/.config/rofi/kaomoji.json
    ROFI_FILE=~/.config/rofi/config.rasi
    
    if [ ! -f "$JSON_FILE" ]; then
      echo "Error: JSON file '$JSON_FILE' not found."
      exit 1
    fi
    
    ARRAY_LENGTH=$(jq -r 'length' "$JSON_FILE")
    RANDOM_INDEX=$((RANDOM % ARRAY_LENGTH))
    RANDOM_VALUE=$(jq -r ".[$RANDOM_INDEX]" "$JSON_FILE")
    perl -i -pe "s/placeholder: \".*?\";/placeholder: \"$RANDOM_VALUE\";/" "$ROFI_FILE"
    
    rofi -show drun
fi
