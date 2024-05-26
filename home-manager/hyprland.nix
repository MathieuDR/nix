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

      general = {
        layout = "master";
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "0x9399b2FF";
        "col.inactive_border" = "0x4488a3EE";
      };

      input = {
        kb_layout = "us";
        kb_options = "grp:alt_shift_toggle,caps:escape";
        touchpad = {
          natural_scroll = false;
          disable_while_typing = true;
        };

        repeat_rate = 40;
        repeat_delay = 250;
        force_no_accel = true;
        sensitivity = 0.3; # -1.0 - 1.0, 0 means no modification.
        follow_mouse = 1;
        numlock_by_default = true;
      };

      decoration = {
        rounding = 7;
        "col.shadow" = "rgba(1a1a1aee)";
        active_opacity = 0.75;
        inactive_opacity = 0.75;
        fullscreen_opacity = 1.0;
        blur = {
          enabled = true;
          size = 4;
          passes = 2;

          brightness = 1;
          contrast = 1.3;
          ignore_opacity = true;
          noise = 1.17e-2;

          new_optimizations = true;
          xray = true;
        };
      };

      animations = {
        enabled = true;
        first_launch_animation = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };
    };

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
