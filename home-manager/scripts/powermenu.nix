{pkgs}:
pkgs.writeShellScriptBin "powermenu" ''
  shutdown='Shutdown'
  reboot='Reboot'
  logout='Log out'
  quit='Quit Hyprland'

  options="$shutdown\n$reboot\n$logout\n$quit"

  opt=$(echo -e $options | ${pkgs.rofi}/bin/rofi -dmenu -p "Power menu")

  case $opt in
  	$quit)
  		run_cmd echo "quit!"
  	;;
  	$logout)
  		run_cmd echo "logout!"
  	;;
  	$reboot)
  		run_cmd echo "reboot!"
  	;;
  	$shutdown)
  		run_cmd echo "shutdown!"
  	;;
  esac
''
