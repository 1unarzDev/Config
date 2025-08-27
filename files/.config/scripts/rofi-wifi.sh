#!/usr/bin/env bash

notify-send --app-name "󰖩" "Getting list of available Wi-Fi networks..."

while true; do
  # Get a list of available wifi connections and morph it into a nice-looking list
  wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")
  if ! [ "$wifi_list" = "" ]; then
    wifi_list+="\n"
  fi

  connected=$(nmcli -fields WIFI g)
  if [[ "$connected" =~ "enabled" ]]; then
    toggle="󰖪  Disable Wi-Fi"
  elif [[ "$connected" =~ "disabled" ]]; then
    toggle="󰖩  Enable Wi-Fi"
  fi

  beginning_options="󰑓  Restart Wi-Fi"
  end_options="  Refresh Networks"

  # Use rofi to select wifi network
  chosen_option=$(echo -e "$toggle\n$beginning_options\n$wifi_list$end_options" | uniq -u | rofi -dmenu -i -selected-row 1 -p "󰖩 " )
  # Get name of connection
  read -r chosen_id <<< "${chosen_option:3}"

  if [ "$chosen_option" = "" ]; then
    exit
  elif [ "$chosen_option" = "󰖩  Enable Wi-Fi" ]; then
    nmcli radio wifi on
  elif [ "$chosen_option" = "󰖪  Disable Wi-Fi" ]; then
    nmcli radio wifi off
  elif [ "$chosen_option" = "󰑓  Restart Wi-Fi" ]; then
    notify-send --app-name "󰑓" "Restarting Wi-Fi..."
    nmcli radio wifi off
    sleep 2
    nmcli radio wifi on
    sleep 3
    notify-send --app-name "󰖩" "Wi-Fi restarted successfully"
  elif [ "$chosen_option" = "  Refresh Networks" ]; then
    continue
  else
    # Message to show when connection is activated successfully
      success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
    # Get saved connections
    saved_connections=$(nmcli -g NAME connection)
    if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
      nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
    else
      if [[ "$chosen_option" =~ "" ]]; then
        wifi_password=$(rofi -dmenu -p "Password: " )
      fi
      nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
      fi
  fi
done
