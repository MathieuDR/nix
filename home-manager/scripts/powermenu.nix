{pkgs}:
pkgs.writeShellScriptBin "powermenu" ''
  shutdown='Shutdown'
  reboot='Reboot'
  logout='Log out'
  quit='Quit Hyprland'

  options="$shutdown\n$reboot\n$quit"

  opt=$(echo -e $options | ${pkgs.rofi-wayland}/bin/rofi -dmenu -i -p "Power menu")

  case $opt in
  	$quit)
  		hyperctl dispatch exit
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
