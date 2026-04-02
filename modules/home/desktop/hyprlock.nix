{...}: {
  # Hyprlock + Hypridle aspect (not enabled for bastion by default)
  # Include this in hosts.nix to enable screen locking
  flake.modules.homeManager.hyprlock = {
    lib,
    config,
    pkgs,
    ...
  }: {
    services.hypridle = let
      hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
      hyprlock = lib.getExe' config.programs.hyprlock.package "hyprlock";
    in {
      enable = true;

      settings = {
        general = {
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
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

    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };

        background = [
          {
            monitor = "";
            color = "rgb(30, 30, 46)";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        label = [
          {
            monitor = "";
            text = "$TIME<br/>$USER";
            font_family = "JetBrainsMono Nerd Font";
            font_size = 50;
            color = "rgb(69, 71, 90)";
            position = "4, 296";
            valign = "center";
            halign = "center";
          }
          {
            monitor = "";
            text = "$TIME<br/>$USER";
            font_family = "JetBrainsMono Nerd Font";
            font_size = 50;
            color = "rgb(205, 214, 244)";
            zindex = 10;
            position = "0, 300";
            valign = "center";
            halign = "center";
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "200, 50";
            position = "0, -100";
            valign = "center";
            halign = "center";
            placeholder_text = "Knocking won't work...";
            hide_input = false;
            fade_on_empty = false;
            outer_color = "rgb(203, 166, 247)";
            inner_color = "rgb(30, 30, 46)";
            font_color = "rgb(205, 214, 244)";
            check_color = "rgb(249, 226, 175)";
            fail_color = "rgb(243, 139, 168)";
          }
        ];
      };
    };
  };
}
