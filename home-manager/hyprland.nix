{ config, pkgs, lib, inputs, ... }:
let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww-daemon &
    #hyprctl setcursor Catppuccin-Mocha-Dark-Cursors 24 &
    
    sleep 1 &
    
    ${pkgs.swww}/bin/swww img ./wallpapers/firewatch.jpg &
    
    floorp &
    kitty &
    discord
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

      monitor = [
        # Left screen 
        "DP-1, 2560x1440, 0x0, 1"
        # Main screen
        #"DP-2, 2560x1440@164.84, 0x0, 1"
        "DP-2, 2560x1440@165, 2560x0, 1"
      ];

      decoration = {
        rounding = 7;
        active_opacity = 0.97;
        inactive_opacity = 0.88;
        fullscreen_opacity = 0.97;
        drop_shadow = true;
      };
      
      input = {
        kb_layout = "us";
        kb_variant = "intl";
        follow_mouse = 2;
        sensitivity = -0.35;
        #force_no_accel = true; #not recommended
        numlock_by_default = true;
      };
      
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        enable_swallow = false; # we probably want to enable this later
        #focus_on_activate = false;
        #middle_click_paste = false; # Somehow doesn't work
      };

      "$mainMod" = "SUPER";
      
      bind = [
        # program shortcuts
        "$mainMod, b, exec, ${pkgs.floorp}/bin/floorp"
        "$mainMod, t, exec, ${pkgs.kitty}/bin/kitty"
        "$mainMod, f, exec, thunar"
	"$mainMod, SLASH, exec, rofi -modes combi -show combi -combi-modes window,drun"
	"$mainMod SHIFT, SLASH, exec, rofi -show drun"
	"$mainMod CTRL, SLASH, exec, rofi -show window"

        # exiting window / hyprland
        "$mainMod, q, killactive,"
        "$mainMod SHIFT, Q, exit,"

        # windows
        "$mainMod, y, togglefloating, active"
	"$mainMod, j, movefocus, d"
	"$mainMod, k, movefocus, u"
	"$mainMod, h, movefocus, l"
	"$mainMod, l, movefocus, r"

	"$mainMod CTRL, j, swapwindow, d"
	"$mainMod CTRL, k, swapwindow, u"
	"$mainMod CTRL, h, swapwindow, l"
	"$mainMod CTRL, l, swapwindow, r"

	"$mainMod SHIFT, j, movewindow, d"
	"$mainMod SHIFT, k, movewindow, u"
	"$mainMod SHIFT, h, movewindow, l"
	"$mainMod SHIFT, l, movewindow, r"

        # workspaces
        "$mainMod_CTRL, down, workspace, r+1"
        "$mainMod_CTRL, up, workspace, r-1"
        "$mainMod_SHIFT, down, movetoworkspace, r+1"
        "$mainMod_SHIFT, up, movetoworkspace, r-1"
      ];

      # Locked
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioStop, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];

      #locked & repeating
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      #mouse
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod CTRL, mouse:272, resizewindow"
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
          "workspaces, 1, 6, winIn, slidevert"
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
      playerctl
    ];
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };
}
