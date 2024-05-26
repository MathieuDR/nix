{ config, pkgs, lib, inputs, ... }:
let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww &
    
    sleep 1
    
    ${pkgs.swww}/bin/swww img ${./wallpapers/firewatch.jpg} &
    
    floorp
    kitty
  '';
in
{
  wayland.windowManager.hyprland = {
    #Catppuccin in ./catppuccin.nix

    settings = {
      exec-once = ''${startupScript}/bin/start'';
    };

    extraConfig = ''
      exec-once = floorp
      exec-once = kitty
    '';

    #plugins = [
    #  inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    #];
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
