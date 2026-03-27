{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.ysomic.applications.espanso;
in {
  options.ysomic.applications.espanso = {
    enable = mkEnableOption "ysomic espanso configuration";

    package = mkOption {
      type = types.package;
      default = pkgs.espanso-wayland;
      description = "The espanso package to use";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.espanso = {
      Unit = {
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        ExecStart = lib.mkForce "/run/wrappers/bin/espanso daemon";
      };
    };

    services.espanso = {
      enable = true;
      package = cfg.package;

      configs = {
        default = {
          show_notifications = false;
          keyboard_layout.layout = "us";
          backend = "auto";
          pre_paste_delay = 300;
        };
      };

      matches = {
        base = {
          matches = [
            {
              trigger = ";date";
              replace = "{{currentdate}}";
            }
            {
              trigger = ";dtime";
              replace = "{{currentdate}} {{currenttime}}";
            }
            {
              trigger = ";epoch";
              replace = "{{epoch}}";
            }
            {
              trigger = ";fdate";
              replace = "{{filedate}}";
            }
            {
              trigger = ";lutm";
              replace = "?utm_source=linkedin&utm_medium=social&utm_campaign=manual%20posts";
            }
            {
              trigger = ";utm";
              replace = "?utm_source=self&utm_medium=direct&utm_campaign=personal_share";
            }
            {
              trigger = ";site";
              replace = "https://mathieu.deraedt.dev";
            }
            {
              trigger = ";@dev";
              replace = "mathieu@deraedt.dev";
            }
            {
              trigger = ";@y";
              replace = "ysomic@gmail.com";
            }
            {
              trigger = ";@g";
              replace = "mathieuderaedt@gmail.com";
            }
            {
              trigger = ";@s";
              replace = "mathieu@7mind.de";
            }
            {
              trigger = ";cout";
              replace = ''
                > [!$|$]
                >
              '';
            }
            {
              trigger = ";ddd";
              force_mode = "clipboard";
              replace = ''
                ```$|$
                ```
              '';
            }
            {
              trigger = ";mfg";
              force_mode = "clipboard";
              replace = ''
                Mit freundlichen Grüßen
                Mathieu De Raedt
              '';
            }
            {
              trigger = ";mvg";
              force_mode = "clipboard";
              replace = ''
                Met vriendelijke groeten
                Mathieu De Raedt
              '';
            }
            {
              trigger = ";kr";
              force_mode = "clipboard";
              replace = ''
                Kind Regards
                Mathieu De Raedt
              '';
            }
            {
              trigger = ";ctac";
              replace = "Find the full set of connected notes in the comments.";
            }
          ];
        };

        global_vars = {
          global_vars = [
            {
              name = "filedate";
              type = "date";
              params = {format = "%Y%m%d";};
            }
            {
              name = "currentdate";
              type = "date";
              params = {format = "%d/%m/%Y";};
            }
            {
              name = "epoch";
              type = "date";
              params = {format = "%s";};
            }
            {
              name = "currenttime";
              type = "date";
              params = {format = "%R";};
            }
          ];
        };
      };
    };
  };
}
