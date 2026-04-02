{...}: {
  flake.modules.homeManager.rofi = {pkgs, ...}: let
    powermenu = pkgs.writeShellScriptBin "powermenu" ''
      menuItems=("Shutdown" "Reboot" "Quit Hyprland")

      menuString=$(printf "%s\n" "''${menuItems[@]}")
      opt=$(echo "$menuString" | ${pkgs.rofi}/bin/rofi -dmenu -i -p "Power menu")

      case $opt in
        "Quit Hyprland")
          hyprctl dispatch exit
          ;;
        "Reboot")
          poweroff --reboot
          ;;
        "Shutdown")
          poweroff -p
          ;;
      esac
    '';
  in {
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [rofi-calc];
    };

    home.packages = [powermenu];
  };
}
