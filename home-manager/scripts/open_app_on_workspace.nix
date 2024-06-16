{pkgs}:
pkgs.writeShellScriptBin "open_in_workspace" ''
  #!/usr/bin/env bash

  command=$1
  workspace=$2

  # Fork the process
  $command &
  pid=$!

  # Detach the process
  disown $pid

  # Try to move the process to the specified workspace
  # Waiting for the window to start
  for i in {1..50}; do
    windows=$(hyprctl clients -j)
    found=$(echo "$windows" | ${pkgs.jq}/bin/jq --arg pid "$pid" 'any(.[]; .pid == ($pid | tonumber))')

    if [[ "$found" == "true" ]]; then
      hyprctl dispatch movetoworkspace "$workspace,pid:$pid"
      break
    fi

    sleep 0.1
  done
''
