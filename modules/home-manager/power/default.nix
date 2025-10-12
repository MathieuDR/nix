{
  config,
  nixosConfig ? {},
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
      default = pkgs.rofi;
      description = "The menu package to use (e.g. rofi, wofi)";
    };

    suspend = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to show the suspend action or not";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.writeShellScriptBin "powermenu" ''
        menuItems=()

        menuItems+=("Shutdown")
        menuItems+=("Reboot")

        ${optionalString config.ysomic.wayland.hyprland.enable "menuItems+=(\"Quit Hyprland\")"}
        ${optionalString config.ysomic.wayland.hyprland.hyprlock.enable "menuItems+=(\"Lock Hyprland\")"}
        ${optionalString cfg.suspend "menuItems+=(\"Suspend\")"}

        # Convert array to newline-separated string for rofi
        menuString=$(printf "%s\n" "''${menuItems[@]}")

        opt=$(echo "$menuString" | ${cfg.launcherPackage}/bin/rofi -dmenu -i -p "Power menu")

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
    home.packages = [cfg.package];
  };
}
