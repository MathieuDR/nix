{
  self,
  pkgs,
  ...
}: let
  wallpaper = "${self}/data/wallpapers/planet.jpg";
in {
  ysomic = {
    applications.defaults = {
      enable = true;
      browser = pkgs.floorp-bin;
      pdfReader = pkgs.zathura;
      terminal = "kitty";
      fileManager = "thunar";
    };

    power.menu = {
      suspend = true;
      # tlpControl = true;
    };

    wayland = {
      hyprland = {
        enable = true;
        #hyprlock.enable = true;
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
}
