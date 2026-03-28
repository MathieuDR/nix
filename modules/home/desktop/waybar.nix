{...}: {
  flake.modules.homeManager.waybar = {
    pkgs,
    config,
    ...
  }: {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = (oldAttrs.mesonFlags or []) ++ ["-Dexperimental=true"];
      });

      settings.mainBar = {
        position = "top";
        layer = "top";
        height = 2;
        margin-top = 3;
        margin-bottom = 0;
        margin-left = 8;
        margin-right = 0;

        modules-left = ["hyprland/window"];
        modules-center = ["clock"];
        modules-right = [
          "group/info"
          "wireplumber"
          "network"
          "group/tray"
          "systemd-failed-units"
          "custom/power"
        ];

        "group/tray" = {
          orientation = "horizontal";
          drawer = {
            children-class = "grouped-module";
            transition-left-to-right = false;
          };
          modules = ["custom/tray-icon" "tray"];
        };

        "custom/tray-icon" = {
          format = "󱊔 ";
          tooltip = false;
        };

        "group/info" = {
          orientation = "horizontal";
          drawer = {
            children-class = "grouped-module";
            transition-left-to-right = false;
          };
          modules = ["memory" "cpu" "disk"];
        };

        systemd-failed-units = {
          hide-on-ok = true;
          format = "󰋔 ";
          system = true;
          user = true;
          on-click = "${config.custom.terminal.command} ${config.custom.terminal.execArgs} sh -c 'systemctl list-units --state=failed,degraded --all --no-pager; systemctl --user list-units --state=failed,degraded --all --no-pager'";
        };

        clock = {
          calendar.format.today = "<span color='#b4befe'><b><u>{}</u></b></span>";
          format = "{:%a, %d/%m %H:%M}";
          format-alt = "  {:%H:%M}";
          tooltip = "false";
        };

        "hyprland/window" = let
          mkRewrite = {
            class,
            suffix ? "",
            icon ? "",
            match ? null,
            rewrite ? null,
          }: {
            name =
              if match != null
              then match
              else "${class} >>> ${
                if suffix == ""
                then "(.*)"
                else ''(.*) ${suffix}''
              }";
            value =
              if rewrite != null
              then rewrite
              else "${icon} $1";
          };

          apps = [
            {
              class = "zen-twilight";
              suffix = "— Zen Twilight";
              icon = " ";
            }
            {
              class = "floorp";
              suffix = "— Ablaze Floorp";
              icon = "󰈹 ";
            }
            {
              class = "discord";
              suffix = "- Discord";
              icon = " ";
            }
            {
              #TODO: The hostname is hardcoded here
              class = "kitty";
              rewrite = "  ${config.home.username}@bastion $1";
            }
            {
              class = "Claude";
              icon = "󰚩 ";
            }
            {
              class = "spotify";
              icon = "󰝚 ";
            }
            {
              class = "org.keepassxc.KeePassXC";
              suffix = "- KeePassXC";
              icon = "󰌾";
            }
            {
              class = "1Password";
              suffix = "— 1Password";
              icon = "󰌾";
            }
          ];

          rewrites =
            builtins.listToAttrs (map mkRewrite apps)
            // {
              "(?!${builtins.concatStringsSep "|" (map (app: app.class) apps)}).* >>> (.*)" = "$1";
            };
        in {
          format = "{class} >>> {title}";
          rewrite = rewrites;
          separate-outputs = true;
        };

        memory = {
          format = "󰟜 {}%";
          format-alt = "󰟜 {used} GiB";
          interval = 10;
        };

        cpu = {
          format = "  {usage}%";
          format-alt = "  {avg_frequency} GHz";
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
          format-muted = "󰖁";
          format-icons = {
            default = [" "];
          };
          scroll-step = 5;
        };

        "custom/power" = {
          format = " ";
          tooltip = false;
          "on-click" = "powermenu";
        };
      };

      style = ''
        /* Base styles */
        * {
            border: none;
            border-radius: 0px;
            font-family: JetBrainsMono Nerd Font;
            font-weight: bold;
            font-size: 15px;
            color: @text;
        }

        window#waybar {
            background: none;
        }

        /* Parent containers basic spacing */
        .modules-left,
        .modules-center,
        .modules-right {
            margin: 0;
            padding: 0;
        }

        /* All direct children of the modules get consistent margins */
        .modules-left > widget > *,
        .modules-center > widget > *,
        .modules-right > widget > * {
            margin: 0 4px;
            padding: 0 4px;
        }
        .modules-left > widget > * {
          margin-left: -3px;
        }

        /* Target the drawer container */
        .modules-right box revealer.drawer box.horizontal {
            padding: 0 4px;
        }

        /* Target the actual modules inside grouped sections */
        .modules-right box revealer.drawer widget.grouped-module label.module {
            margin: 0 3px;
            padding: 0 3px;
        }

        /* Remove left margin from first widget */
        .modules-left > widget:first-child > *,
        .modules-center > widget:first-child > *,
        .modules-right > widget:first-child > *,
        .grouped-module:first-child {
            /* margin-left: 0;
            padding-left: 0; */
        }

        /* Remove right margin from last widget */
        .modules-left > widget:last-child > *,
        .modules-center > widget:last-child > *,
        .modules-right > widget:last-child > * {
            /* margin-right: 0;
            padding-right: 0; */
        }

        /* All module contents get hover effects */
        .modules-left > widget > *:hover,
        .modules-center > widget > *:hover,
        .modules-right > widget > *:hover {
            color: @mauve;
        }

        /* Status-specific styles that need to override the defaults */
        #battery.warning { color: @peach; }
        #battery.critical { color: @red; }
        #battery.charging { color: @green; }
        #systemd-failed-units.degraded { color: @red; }
      '';
    };
  };
}
