#!/usr/bin/env bash

action=$1

sink="@DEFAULT_AUDIO_SINK@"

get_volume() {
  wpctl get-volume "$sink" | awk '{print $2}'
}

set_volume() {
  current=$(get_volume)
  step=0.05
  if [ "$1" = "up" ]; then
    new=$(echo "$current + $step" | bc)
    [ "$(echo "$new > 1.0" | bc)" -eq 1 ] && new=1.0
  else
    new=$(echo "$current - $step" | bc)
    [ "$(echo "$new < 0.0" | bc)" -eq 1 ] && new=0.0
  fi
  wpctl set-volume "$sink" "$new"
}

toggle_mute() {
  wpctl set-mute "$sink" toggle
}

show_status() {
  volume=$(get_volume)
  muted=$(wpctl get-volume "$sink" | grep -q MUTED && echo true || echo false)
  percent=$(printf "%03d" $(echo "$volume * 100" | bc | cut -d'.' -f1))
  [ "$percent" -gt 100 ] && percent=100

  if [ "$muted" = true ] || [ "$percent" -eq 0 ]; then
    icon="󰖁"
  elif [ "$percent" -le 33 ]; then
    icon="󰕿"
  elif [ "$percent" -le 66 ]; then
    icon="󰖀"
  else
    icon="󰕾"
  fi

  echo "{\"text\": \"$icon $percent%\", \"tooltip\": \"Volume: $percent%\"}"
}

case "$action" in
  up) set_volume up ;;
  down) set_volume down ;;
  mute) toggle_mute ;;
  *) show_status ;;
esac
