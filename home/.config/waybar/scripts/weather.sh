#!/usr/bin/env bash

mode_file="$HOME/.config/waybar/scripts/weather_mode"
[ -f "$mode_file" ] || echo "default" > "$mode_file"

if [ "$1" = "toggle" ]; then
  current=$(cat "$mode_file")
  next="default"
  [ "$current" = "default" ] && next="alt"
  echo "$next" > "$mode_file"
  exit 0
fi

mode=$(cat "$mode_file")

# Get weather data: condition, feels like temp, actual temp, and location
weather=$(curl -s "wttr.in/?format=%C+%f+%t+%l")
condition=$(echo "$weather" | cut -d' ' -f1)
feels_like=$(echo "$weather" | cut -d' ' -f2)
actual_temp=$(echo "$weather" | cut -d' ' -f3)
location=$(echo "$weather" | cut -d' ' -f4-)

# Format feels like temp
sign=${feels_like:0:1}
num=$(echo "$feels_like" | grep -o '[0-9]\+')
unit="°F"
fixed_feels="${sign}$(printf "%03d" "$num")${unit}"

# Format actual temp
sign_actual=${actual_temp:0:1}
num_actual=$(echo "$actual_temp" | grep -o '[0-9]\+')
fixed_actual="${sign_actual}$(printf "%03d" "$num_actual")${unit}"

# Choose icon based on condition
case "$condition" in
  Sunny|Clear) icon="󰖙" ;;
  Partly*) icon="󰖕" ;;
  Cloudy|Overcast) icon="󰖐" ;;
  Rain|Showers|Drizzle) icon="󰖗" ;;
  Thunderstorm) icon="󰖓" ;;
  Snow|Flurries) icon="󰖘" ;;
  Mist|Fog|Haze) icon="󰖑" ;;
  *) icon="󰋖" ;;
esac

# Output based on mode
if [ "$mode" = "alt" ]; then
  echo "{\"text\": \"$icon $location $fixed_actual\"}"
else
  echo "{\"text\": \"$icon $fixed_feels\"}"
fi
