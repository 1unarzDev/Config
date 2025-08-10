#!/bin/sh
WALLPAPER_DIR="$HOME/.config/swww/wallpapers"
STATE_FILE="$HOME/.cache/current_wallpaper"
WALLPAPER_CACHE="$HOME/.cache/current_wallpaper_file"
CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"
PYWAL_SPICETIFY="$HOME/.cache/wal/colors-spicetify.ini"
SPICETIFY_CONFIG="$HOME/.config/spicetify/Themes/text/color.ini"
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"
MAKO_CONFIG="$HOME/.config/mako/config"
SWAYOSD_DIR="$HOME/.config/swayosd"

# Get all images
images=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | sort)
total=$(echo "$images" | wc -l)

# Get current index
current=$(cat "$STATE_FILE" 2>/dev/null || echo "0")
next=$(( (current + $1) % total ))

# Get the image
image=$(echo "$images" | sed -n "$((next + 1))p")

# Set wallpaper with transition
scale=$(grep "^monitor=" $CONFIG_FILE | cut -d',' -f4)
cursor_raw=$(hyprctl cursorpos)

x=$(echo "$cursor_raw" | cut -d',' -f1 | tr -d ' ')
y=$(echo "$cursor_raw" | cut -d',' -f2 | tr -d ' ')

x=$(echo "$x * $scale" | bc | cut -d'.' -f1)
y=$(echo "$y * $scale" | bc | cut -d'.' -f1)

cursor="$x,$y"
swww img $image --transition-type grow --transition-pos $cursor --invert-y --transition-step 2 --transition-fps 60 --transition-duration 2
sleep 1.1

# Update pywal
wal -e -n -i "$image"

# Terminal colors
source ~/.cache/wal/colors.sh

# Update config file
sed -i "s/col\.active_border = .*/col.active_border = rgba(${color5#\#}ee) rgba(${color7#\#}ee) 45deg/" "$CONFIG_FILE"
sed -i "s/col\.inactive_border = .*/col.inactive_border = rgba(${color8#\#}aa)/" "$CONFIG_FILE"

# Hyprlock wallpaper
sed -i "s|path = .*|path = $image|" "$HYPRLOCK_CONFIG"

# Mako notifications
sed -i -e "s/background-color=#[0-9a-fA-F]\{6,8\}/background-color=${color0}dd/" \
       -e "s/text-color=#[0-9a-fA-F]\{6,8\}/text-color=${color15}dd/" \
       -e "s/border-color=#[0-9a-fA-F]\{6,8\}/border-color=${color4}dd/" $MAKO_CONFIG
makoctl reload

# Swayosd
sed "s/BACKGROUND_COLOR/$background/g; \
     s/BORDER_COLOR/$foreground/g; \
     s/FOREGROUND_COLOR/$foreground/g; \
     s/PROGRESS_BG_COLOR/$background/g; \
     s/PROGRESS_COLOR/$foreground/g; \
     s/ICON_COLOR/$foreground/g" \
     $SWAYOSD_DIR/style.css.template > $SWAYOSD_DIR/style.css
pkill -9 swayosd-server 2>/dev/null
swayosd-server -s "$SWAYOSD_DIR/style.css" >/dev/null 2>&1 &
disown

# Also update runtime (for immediate effect)
hyprctl keyword general:col.active_border "rgba(${color5#\#}ee) rgba(${color7#\#}ee) 45deg"
hyprctl keyword general:col.inactive_border "rgba(${color8#\#}aa)"

# Update spicetify colors
tmpfile=$(mktemp)
awk -v new_section_file="$PYWAL_SPICETIFY" '
    BEGIN {
        section_found = 0
        in_pywal = 0
        while ((getline line < new_section_file) > 0) {
            gsub(/#/, "", line)
            new_section_lines[++num_new_lines] = line
        }
        close(new_section_file)
    }

    /^\[pywal\]/ {
        section_found = 1
        in_pywal = 1
        print "[pywal]"
        for (i = 1; i <= num_new_lines; i++) print new_section_lines[i]
        next
    }

    /^\[/ && in_pywal {
        in_pywal = 0
    }

    !in_pywal {
        print
    }

    END {
        if (!section_found) {
            print ""
            print "[pywal]"
            for (i = 1; i <= num_new_lines; i++) print new_section_lines[i]
        }
    }
' "$SPICETIFY_CONFIG" > "$tmpfile"
mv "$tmpfile" "$SPICETIFY_CONFIG"

# Save current index
echo "$next" > "$STATE_FILE"
