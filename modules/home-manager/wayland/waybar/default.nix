{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.ysomic.wayland.waybar;
  powerMenu = config.ysomic.power.menu;
in {
  options.ysomic.wayland.waybar = {
    enable = mkEnableOption "Custom Waybar configuration";

    battery = mkOption {
      type = types.bool;
      default = false;
      description = "Enable battery indicator in the right modules";
    };

    # Theme options
    theme = {
      font = mkOption {
        type = types.str;
        default = "JetBrainsMono Nerd Font";
        description = "Font family to use";
      };

      font_size = mkOption {
        type = types.str;
        default = "15px";
        description = "Font size with unit";
      };

      font_weight = mkOption {
        type = types.str;
        default = "bold";
        description = "Font weight";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs.waybar = {
        enable = true;
        package = pkgs.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = (oldAttrs.mesonFlags or []) ++ ["-Dexperimental=true"];
        });
        settings = {
          mainBar = {
            position = "top";
            layer = "top";
            height = 2;
            margin-top = 3;
            margin-bottom = 0;
            margin-left = 8;
            margin-right = 0;
            modules-left = [
              "hyprland/window"
            ];
            modules-center = [
              "clock"
            ];
            modules-right =
              [
                "group/info"
                "wireplumber"
                "network"
                "custom/power"
              ]
              ++ optional powerMenu.enable "custom/power"
              ++ optional cfg.battery "battery";

            "group/info" = {
              orientation = "horizontal";
              drawer = {
                children-class = "group-info";
                transition-left-to-right = false;
              };
              modules = [
                "memory"
                "cpu"
                "disk"
              ];
            };

            clock = {
              calendar = {
                format = {today = "<span color='#b4befe'><b><u>{}</u></b></span>";};
              };
              format = "{:%a, %d/%m %H:%M}";
              format-alt = "  {:%H:%M}";
              tooltip = "false";
            };

            "hyprland/window" = {
              format = "{title}";
              rewrite = {
                "(.*) — Ablaze Floorp" = "󰈹 $1";
                "(.*) - Discord" = "  $1";
                ".*thieu\@anchor: (.*)" = "  $1";
              };
              separate-outputs = true;
            };

            memory = {
              format = "󰟜 {}%";
              format-alt = "󰟜 {used} GiB"; # 
              interval = 10;
            };

            cpu = {
              format = "  {usage}%";
              format-alt = "  {avg_frequency} GHz";
              interval = 10;
            };

            disk = {
              format = "󰋊 {percentage_used}%";
              format-alt = "󰋊 {specific_free:0.2f} GiB free";
              unit = "GiB";
              interval = 120;
            };

            network = {
              format-wifi = "  {signalStrength}%";
              format-ethernet = "󰀂 ";
              tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
              format-linked = "{ifname} (No IP)";
              format-disconnected = "󰖪 ";
            };

            tray = {
              icon-size = 20;
              spacing = 8;
            };

            wireplumber = {
              format = "{icon} {volume}%";
              format-muted = "󰖁 ";
              format-icons = {
                default = ["  "];
              };
              scroll-step = 5;
            };

            battery = mkIf cfg.battery {
              format = "{icon} {capacity}%";
              format-icons = ["" "" "" "" ""];
              format-charging = "⚡ {capacity}%";
              interval = 30;
              states = {
                warning = 30;
                critical = 15;
              };
            };
          };
        };

        style = ''
          * {
              border: none;
              border-radius: 0px;
              padding: 0;
              margin: 0;
              min-height: 0px;
              font-family: ${cfg.theme.font};
              font-weight: ${cfg.theme.font_weight};
          }

          window#waybar {
              background: none;
          }

          .group-info, #window, #wireplumber, #network, #cpu, #memory, #disk, #clock, .group-power, #custom-power, #battery{
              font-size: ${cfg.theme.font_size};
              color: @text;
          }

          #custom-power{
          	padding-left: 2px;
          	padding-right: 8px;
          }

          #custom-power:hover, #network:hover, #cpu:hover, #memory:hover, #disk:hover, #clock:hover, #wireplumber:hover, #window:hover {
          	color: @mauve;
          }

          #cpu {
              padding-left: 15px;
              padding-right: 9px;
              margin-left: 7px;
          }

          #memory {
              padding-left: 4px;
              padding-right: 9px;
          }

          #disk {
              padding-left: 9px;
              padding-right: 10px;
          }

          #wireplumber {
              padding-left: 4px;
              padding-right: 6px;
          }

          #window {
          	padding-left: 4px;
          }

          #network {
              padding-left: 5px;
              padding-right: 8px;
          }

          #battery {
            padding-left: 5px;
            padding-right: 8px;
          }

          #battery.warning {
            color: @peach;
          }

          #battery.critical {
            color: @red;
          }

          #battery.charging {
            color: @green;
          }
        '';
      };
    })

    # Power menu specific configuration
    (mkIf (cfg.enable && powerMenu.enable) {
      programs.waybar.settings.mainBar."custom/power" = {
        format = " ";
        tooltip = false;
        "on-click" = lib.getExe powerMenu.package;
      };
    })
  ];
}
