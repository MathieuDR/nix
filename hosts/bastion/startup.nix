{
  pkgs,
  config,
  inputs,
  ...
}: let
  wallpaper = "${inputs.self}/data/wallpapers/firewatch.jpg";
in {
  wayland.windowManager.hyprland.settings.exec-once = [
    # System tray and wallpaper daemon
    "waybar"
    "${pkgs.swww}/bin/swww-daemon"
    "copyq --start-server"

    # Set wallpaper
    "${pkgs.swww}/bin/swww img ${wallpaper}"

    # Applications
    "${pkgs.discord}/bin/discord --in-progress-gpu --use-gl=desktop"
    "${config.programs.spicetify.spicedSpotify}/bin/spotify"
    config.custom.browser.command
    config.custom.terminal.command
  ];
}
