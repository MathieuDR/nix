# Current, naive implementation
{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ysomic.wayland.hyprland;
in {
  config = lib.mkMerge [
    #
    (lib.mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        enable = true;

        settings = {
          general = {
            layout = "dwindle";
            gaps_in = 5;
            gaps_out = 5;
            border_size = 2;
            "col.inactive_border" = "$surface1";
            "col.active_border" = "$mauve";
          };

          group = {
            "col.border_inactive" = "$surface1";
            "col.border_active" = "$mauve";
          };
          decoration = {
            rounding = 7;
            active_opacity = 0.97;
            inactive_opacity = 0.85;
            fullscreen_opacity = 1;
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

          "$mainMod" = "SUPER";

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

          bind = [
            # program shortcuts
            "$mainMod, b, exec, ${pkgs.floorp}/bin/floorp"
            "$mainMod, t, exec, ${pkgs.kitty}/bin/kitty"
            "$mainMod, f, exec, thunar"
            "$mainMod, e, fullscreen"
            "$mainMod, SLASH, exec, rofi -modes combi,calc -show combi -combi-modes window,drun"
            "$mainMod SHIFT, SLASH, exec, rofi -show drun"
            "$mainMod CTRL, SLASH, exec, rofi -show window"
            "$mainMod ALT, SEMICOLON, exec, copyq show"

            # exiting window / hyprland
            "$mainMod, q, killactive,"
            "$mainMod SHIFT, Q, exec, powermenu"

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

            # utilities
            ", Print, exec, grimblast save area - | swappy -f -"
          ];

          #mouse
          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod CTRL, mouse:272, resizewindow"
          ];

          windowrulev2 = [
            #copyq
            "float, class:(com.github.hluk.copyq)"
            "size 400 400, class:(com.github.hluk.copyq)"

            # Sharing floorp
            "float, class:(floorp), title:(Floorp — Sharing Indicator)"
            "suppressevent fullscreen maximize activate activatefocus, class:(floorp), title:(Floorp — Sharing Indicator)"
            "size 55 32, class:(floorp), title:(Floorp — Sharing Indicator)"
            "move 5 1400, class:(floorp), title:(Floorp — Sharing Indicator)"

            # Videos
            "opaque, class:(floorp), title:(YouTube)"
            "opaque, class:(floorp), title:(Prime Video)"
            "opaque, class:(Nomifactory.*)"
          ];
        };
      };

      home = {
        packages = with pkgs; [
          libnotify
          swww
          playerctl
          grimblast
          swappy
        ];
      };

      xdg.configFile."swappy/config" = {
        enable = true;
        text = ''
          [Default]
             save_dir=$HOME/pictures/screenshots
             save_filename_format=screenshot-%Y%m%d-%H%M%S.png
             show_panel=true
             line_size=5
             text_size=20
             text_font=JetBrainsMono Nerd Font
             paint_mode=brush
             early_exit=false
             fill_shape=false
        '';
      };

      services.dunst = {
        enable = true;
      };
    })
  ];
}
