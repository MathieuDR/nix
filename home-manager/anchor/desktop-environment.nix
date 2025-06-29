{
  self,
  pkgs,
  config,
  inputs,
  ...
}: let
  wallpaper = "${self}/data/wallpapers/firewatch.jpg";
in {
  ysomic = {
    applications.defaults = {
      enable = true;
      browser = config.programs.zen-browser.finalPackage;
      pdfReader = pkgs.zathura;
      terminal = "kitty";
      fileManager = "thunar";
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

          # postInit = ''
          #   # hyprctl dispatch workspace 4 &
          # '';
        };
      };

      waybar.enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
    ];

    settings = {
      # exec-once = [
      #   "${pkgs.discord}/bin/discord --in-progress-gpu --use-gl=desktop"
      #   "${pkgs.spotify}/bin/spotify"
      #   "${pkgs.floorp}/bin/floorp"
      #   "${pkgs.kitty}/bin/kitty"
      # ];

      # bind = [
      # ];

      # workspace = [
      #   "name:1, monitor:DP-1, persistent:true"
      #   "name:2, monitor:DP-2, persistent:true"
      #   "name:3, monitor:DP-1, persistent:true"
      #   "name:4, monitor:DP-2, persistent:true"
      #   "name:5, monitor:DP-1, persistent:true"
      #   "name:6, monitor:DP-2, persistent:true"
      #   "name:7, monitor:DP-1, persistent:true"
      #   "name:8, monitor:DP-2, persistent:true"
      # ];

      monitor = [
        # Left screen
        "DP-1, 2560x1440, 0x0, 1"
        # Main screen
        "DP-2, 2560x1440@165, 2560x0, 1"
      ];
    };
  };
}
