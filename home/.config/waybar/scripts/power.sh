#!/usr/bin/env bash

declare -A cmd
cmd=(
  ["h"]="hibernate"
  ["r"]="reboot"
  ["s"]="poweroff"
)

declare -A msg 
msg=(
  ["hl"]="hibernate"
  ["hr"]="hibernating"
  ["rl"]="restart"
  ["rr"]="restarting"
  ["sl"]="shut down"
  ["sr"]="shutting down"
)

key="$1$2"

if [[ "$2" == "l" ]]; then
  notify-send "power" "${msg[$key]}?\nplease confirm"

  choice=$(echo -e "ok\ncancel" | fuzzel --dmenu -p "${msg[$key]}?")

  if [[ "$choice" == "ok" ]]; then
    systemctl "${cmd[$1]}"
  fi
elif [[ "$2" == "r" ]]; then
  notify-send "power" "${msg[$key]} in 5 seconds"
  
  sleep 5
  systemctl "${cmd[$1]}"
fi
