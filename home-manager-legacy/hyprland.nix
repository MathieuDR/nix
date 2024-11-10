{pkgs, ...}: let
  wallpapers = builtins.path {
    name = "wallpapers";
    path = ./wallpapers;
  };

  wallpaper = ./wallpapers/firewatch.jpg;

  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    waybar &
    swww-daemon &
    copyq --start-server &
    sleep 0.5 &

    #TODO: Make this not impure, but import the location / script?
    # open_in_workspace "whatsapp-for-linux" 1 &
    open_in_workspace "discord --in-progress-gpu --use-gl=desktop" 1 &
    open_in_workspace "spotify" 2 &
    open_in_workspace "floorp" 3 &
    open_in_workspace "kitty" 4 &
    sleep 0.5 &

    ${pkgs.swww}/bin/swww img ${wallpaper} &
    sleep 0.5 &

    hyprctl dispatch workspace 4 &
    #nohup hyprlock &
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = ''${startupScript}/bin/start'';

      workspace = [
        "name:1, monitor:DP-1, persistent:true"
        "name:2, monitor:DP-2, persistent:true"
        "name:3, monitor:DP-1, persistent:true"
        "name:4, monitor:DP-2, persistent:true"
        "name:5, monitor:DP-1, persistent:true"
        "name:6, monitor:DP-2, persistent:true"
        "name:7, monitor:DP-1, persistent:true"
        "name:8, monitor:DP-2, persistent:true"
      ];

      monitor = [
        # Left screen
        "DP-1, 2560x1440, 0x0, 1"
        # Main screen
        "DP-2, 2560x1440@165, 2560x0, 1"
      ];
    };
  };

  home = {
    file."wallpapers" = {
      source = wallpapers;
      target = "wallpapers/";
    };
  };
}
