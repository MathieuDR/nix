{
  self,
  pkgs,
  config,
  ...
}: let
  wallpaper = "${self}/data/wallpapers/firewatch.jpg";
in {
  ysomic = {
    applications = {
      browser = {
        enable = true;
        package = config.programs.zen-browser.finalPackage;
      };

      defaults.fileManager = "thunar";
      pdfReader.enable = true;
      terminal.enable = true;
    };

    wayland = {
      hyprland = {
        enable = true;
        hyprlock.enable = false;
        wallpaper = wallpaper;

        startupScript = {
          init = [
            "${pkgs.discord}/bin/discord --in-progress-gpu --use-gl=desktop"
            "${config.programs.spicetify.spicedSpotify}/bin/spotify"
            "${config.programs.zen-browser.finalPackage}/bin/zen"
            "${pkgs.kitty}/bin/kitty"
          ];
        };
      };

      waybar.enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        # Left screen
        "DP-3, 2560x1440, 0x0, 1"
        # Main screen
        "DP-1, 2560x1440@165, 2560x0, 1"
      ];
    };
  };
}
