{
  self,
  pkgs,
  ...
}: let
  wallpaper = "${self}/data/wallpapers/firewatch.jpg";
in {
  ysomic = {
    applications.defaults = {
      enable = true;
      browser = pkgs.floorp;
      pdfReader = pkgs.zathura;
      terminal = "kitty";
      fileManager = "thunar";
    };

    power.menu = {
      suspend = true;
      tlpControl = true;
    };

    wayland = {
      hyprland = {
        enable = true;
        hyprlock.enable = true;
        wallpaper = wallpaper;

        # startupScript = {
        #   init = ''
        #     open_in_workspace "discord --in-progress-gpu --use-gl=desktop" 1 &
        #     open_in_workspace "spotify" 2 &
        #     open_in_workspace "floorp" 3 &
        #     open_in_workspace "kitty" 4 &
        #   '';
        #
        #   postInit = ''
        #     hyprctl dispatch workspace 4 &
        #   '';
        # };
      };

      waybar = {
        enable = true;
        battery = true;
      };
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
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
      #
      # monitor = [
      #   # Left screen
      #   "DP-1, 2560x1440, 0x0, 1"
      #   # Main screen
      #   "DP-2, 2560x1440@165, 2560x0, 1"
      # ];
    };
  };
}
