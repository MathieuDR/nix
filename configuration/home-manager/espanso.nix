{
  pkgs,
  nixosConfig,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      _espanso-wayland-orig = prev.espanso-wayland;
      espanso-wayland = pkgs.callPackage ./overrides/espanso.nix {
        capDacOverrideWrapperDir = "${nixosConfig.security.wrapperDir}";
        espanso = prev.espanso-wayland;
      };
    })
  ];
  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;

    configs = {
      default = {
        show_notifications = false;
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
            trigger = ";@g";
            replace = "mathieuderaedt@gmail.com";
          }
          {
            trigger = ";@7";
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
            replace = ''
              Mit freundlichen Grüßen
              Mathieu De Raedt
            '';
          }
          {
            trigger = ";mvg";
            replace = ''
              Met vriendelijke groeten
              Mathieu De Raedt
            '';
          }
          {
            trigger = ";kr";
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
}
