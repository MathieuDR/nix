{pkgs}:
pkgs.writeShellScriptBin "open_kiosk_in_window_and_workspace" ''
  #!/usr/bin/env bash

  exe=$1
  url=$2
  class=$3
  workspace=$4

  # Fork the process
  $exe --kiosk --new-window "$url" &
  pid=$!
  echo "$pid"

  # Detach the process
  disown $pid

  # Try to move the process to the specified workspace
  # Waiting for the window to start
  for _i in {1..50}; do
    windows=$(hyprctl clients -j)
  	address=$(echo "$windows" | jq --arg class "$class" -r '.[] | select(.class == $class and .fullscreen == true) | .address')

    if [[ -n "$address" ]]; then
  		echo "address: $address"
  		hyprctl dispatch movefocus "address:$address"
  		hyprctl dispatch fullscreen
      hyprctl dispatch movetoworkspace "$workspace,address:$address"
      break
  	else
  		echo "not found"
    fi

    sleep 0.1
  done
''
