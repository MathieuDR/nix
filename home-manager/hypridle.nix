{
  lib,
  config,
  pkgs,
  ...
}: let
  hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
  hyprlock = lib.getExe' config.programs.hyprlock.package "hyprlock";
  lock = "${pkgs.systemd}/bin/loginctl lock-session";
in {
  programs.hypridle = {
    enable = true;

    settings = {
      general = {
        before_sleep_cmd = "${lock}";
        lock_cmd = "${hyprlock}";
      };

      listener = [
        {
          timeout = 300; # 5 min
          onTimeout = "${hyprctl} dispatch dpms off";
          on-resume = "${hyprctl} dispatch dpms on";
        }

        {
          timeout = 600; # 10 min
					on-timeout = "loginctl lock-session";
        }
      ];
    };
  };
}
