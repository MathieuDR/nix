{pkgs}:
pkgs.writeShellScriptBin "powermenu" ''
  shutdown='Shutdown'
  reboot='Reboot'
  logout='Log out'
  lock='Lock Hyprland'
  quit='Quit Hyprland'

  options="$shutdown\n$reboot\n$lock\n$quit"

  opt=$(echo -e $options | ${pkgs.rofi-wayland}/bin/rofi -dmenu -i -p "Power menu")

  case $opt in
  $lock)
  	nohup hyprlock &
  	sleep 2
  ;;
  	$quit)
  		hyprctl dispatch exit
  	;;
  	$logout)
  		echo "woopsie, not implemented"
  	;;
  	$reboot)
  		poweroff --reboot
  	;;
  	$shutdown)
  		poweroff -p
  	;;
  esac
''
