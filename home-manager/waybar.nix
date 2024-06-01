{pkgs, ...}: let
  wtheme = {
    font = "JetBrainsMono";
    font_size = "15px";
    font_weight = "bold";
    opacity = "0.90";
    text_color = "#cdd6f4";
    accent = "89b4fa";
    background = "11111B";
  };
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = (oldAttrs.mesonFlags or []) ++ ["-Dexperimental=true"];
    });
    settings = {
      mainBar = {
        possition = "top";
        layer = "top";
        height = 2;
        margin-top = 3;
        margin-bottom = 0;
        margin-left = 8;
        margin-right = 0;
        modules-left = [
          "hyprland/window"
          # "tray"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
					"group/info"
          "wireplumber"
          "network"
					"custom/power"
        ];
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
				"custom/power" = {
					format = " ";
					tooltip = false;
					"on-click" = "powermenu";
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
           	".*Thieu\@nixos: (.*)" = "  $1";
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
      };
    };

    style = ''
      * {
          border: none;
          border-radius: 0px;
          padding: 0;
          margin: 0;
          min-height: 0px;
          font-family: ${wtheme.font};
          font-weight: ${wtheme.font_weight};
      }

      window#waybar {
          background: none;
      }

      .group-info, #window, #wireplumber, #network, #cpu, #memory, #disk, #clock, .group-power, custom-power{
          font-size: ${wtheme.font_size};
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
    '';
  };
}
