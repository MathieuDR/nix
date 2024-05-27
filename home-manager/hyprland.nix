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
    enable = true;

    settings = {
      exec-once = ''${startupScript}/bin/start'';

      general = {
        layout = "dwindle";
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
      };

      decoration = {
        rounding = 2;
        inactive_opacity = 0.2;
        fullscreen_opacity = 0.2;
        drop_shadow = true;
      };
      
      input = {
        kb_layout = "us";
        kb_variant = "intl";
        follow_mouse = 2;
        #force_no_accel = true; not recommended
        numlock_by_default = true;
      };
      
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        enable_swallow = false; # we probably want to enable this later
        #middle_click_paste = false; # Somehow doesn't work
      };

      "$mainMod" = "SUPER";
      
      bind = [
        "$mainMod, b, exec, ${pkgs.floorp}/bin/floorp"
        "$mainMod, return, exec, ${pkgs.kitty}/bin/kitty"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod_CTRL, up, workspace, +1"
        "$mainMod_CTRL, down, workspace, -1"
        "$mainMod_CTRL_SHIFT, up, movetoworkspace, +1"
        "$mainMod CTRL SHIFT, down, movetoworkspace, -1"
      ];
      
      animations = {
        enabled = true;
        first_launch_animation = true;
        bezier = [
          "wind, 0.05, 0.09, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.03, -0.03, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
      
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 6, winOut, slide"
          "windowsMove, 1, 6, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 8, wind, slidevert"
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
