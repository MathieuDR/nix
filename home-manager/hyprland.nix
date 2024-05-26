{ config, pkgs, lib, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = { };

    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
  };

  home = {
    packages = with pkgs; [
      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      dunst
      libnotify
      swww
      rofi-wayland
    ];
  };
}
