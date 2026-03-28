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

        modules-left = [];
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

        "hyprland/window" = {
          format = "{class} >>> {title}";
          rewrite = {
            "floorp >>> (.*) — Ablaze Floorp" = "󰈹  $1";
            "Slack >>> (.*) - Slack" = "  $1";
            "discord >>> (.*) - Discord" = "  $1";
            "kitty >>> (.*)" = "  ${config.home.username}@bastion $1";
            "spotify >>> (.*)" = "󰝚  $1";
            "org.keepassxc.KeePassXC >>> (.*) - KeePassXC" = "󰌾 $1";
            "1Password >>> (.*) — 1Password" = "󰌾 $1";
            "(?!floorp|Slack|discord|kitty|spotify|org.keepassxc.KeePassXC|1Password).* >>> (.*)" = "$1";
          };
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
          format-wifi = "  {signalStrength}%";
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
          format-icons.default = [" "];
          scroll-step = 5;
        };

        "custom/power" = {
          format = " ";
          tooltip = false;
          "on-click" = "powermenu";
        };
      };

      style = ''
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

        .modules-left,
        .modules-center,
        .modules-right {
            margin: 0;
            padding: 0;
        }

        .modules-left > widget > *,
        .modules-center > widget > *,
        .modules-right > widget > * {
            margin: 0 4px;
            padding: 0 4px;
        }
        .modules-left > widget > * {
          margin-left: -3px;
        }

        .modules-right box revealer.drawer box.horizontal {
            padding: 0 4px;
        }

        .modules-right box revealer.drawer widget.grouped-module label.module {
            margin: 0 3px;
            padding: 0 3px;
        }

        .modules-left > widget > *:hover,
        .modules-center > widget > *:hover,
        .modules-right > widget > *:hover {
            color: @mauve;
        }

        #battery.warning { color: @peach; }
        #battery.critical { color: @red; }
        #battery.charging { color: @green; }
        #systemd-failed-units.degraded { color: @red; }
      '';
    };
  };
}
