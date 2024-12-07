{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.ysomic.power.menu;
in {
  options.ysomic.power.menu = {
    enable = mkEnableOption "Power management utilities";

    launcherPackage = mkOption {
      type = types.package;
      default = pkgs.rofi-wayland;
      description = "The menu package to use (e.g. rofi-wayland, wofi)";
    };

    suspend = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to show the suspend action or not";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.writeShellScriptBin "powermenu" ''
        menuItems=$(cat << EOF
        Shutdown
        Reboot
        ${optionalString config.ysomic.wayland.hyprland.enable "Quit Hyprland"}
        ${optionalString config.ysomic.wayland.hyprland.hyprlock.enable "Lock Hyprland"}
        ${optionalString cfg.menu.suspend "Suspend"}
        EOF
        )

        opt=$(echo "$menuItems" | ${cfg.menu.launcherPackage}/bin/rofi -dmenu -i -p "Power menu")

        case $opt in
          "Lock Hyprland")
            nohup hyprlock &
            sleep 2
            ;;
          "Quit Hyprland")
            hyprctl dispatch exit
            ;;
          "Suspend")
            systemctl suspend
            ;;
          "Reboot")
            poweroff --reboot
            ;;
          "Shutdown")
            poweroff -p
            ;;
        esac
      '';
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.menu.package];
  };
}
