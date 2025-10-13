{
  lib,
  config,
  ...
}: let
  cfg = config.ysomic.wayland.hyprland.hyprlock;
in {
  options.ysomic.wayland.hyprland.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock";

    monitor = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "The monitor to show the lockscreen on, if empty it will display on all monitors.";
      example = "DP-2";
    };

    lockOnStartup = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If hyprlock should be started together with Hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    ysomic.wayland.hyprland.startupScript.postInit = lib.mkAfter ''
      ${lib.optionalString cfg.lockOnStartup "nohup hyprlock &"}
    '';

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
            monitor = cfg.monitor;
            text = "$TIME<br/>$USER";
            font_family = "JetBrainsMono Nerd Font";
            font_size = 50;

            color = "rgb(69, 71, 90)";
            position = "4, 296";

            valign = "center";
            halign = "center";
          }

          {
            monitor = cfg.monitor;
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
            monitor = cfg.monitor;
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
