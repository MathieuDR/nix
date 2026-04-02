{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    config,
    osConfig,
    ...
  }:
    lib.mkIf osConfig.programs.hyprland.enable {
      wayland.windowManager.hyprland = {
        package = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
            shadow.enabled = true;
          };

          input = {
            kb_layout = "us";
            kb_variant = "intl";
            follow_mouse = 2;
            sensitivity = -0.35;
            numlock_by_default = true;
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            force_default_wallpaper = 0;
            enable_swallow = false;
          };

          animations = {
            enabled = true;
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

          bindl = [
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioStop, exec, playerctl play-pause"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XF86AudioNext, exec, playerctl next"
          ];

          bindel = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ];

          bind = [
            # program shortcuts
            "$mainMod, b, exec, ${config.custom.browser.command}"
            "$mainMod, t, exec, ${config.custom.terminal.command}"
            "$mainMod, f, exec, ${config.custom.fileManager.command}"
            "$mainMod, s, exec, rofi-systemd"
            "$mainMod, e, fullscreen"
            "$mainMod, SLASH, exec, ${config.custom.launcher.command} -modes combi,calc -show combi -combi-modes window,drun"
            "$mainMod SHIFT, SLASH, exec, ${config.custom.launcher.drunCommand}"
            "$mainMod CTRL, SLASH, exec, ${config.custom.launcher.windowCommand}"
            "$mainMod ALT, SEMICOLON, exec, copyq show"

            # window management
            "$mainMod, q, killactive,"
            "$mainMod SHIFT, Q, exec, powermenu"

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

          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod CTRL, mouse:272, resizewindow"
          ];

          windowrule = [
            # copyq
            "float on, match:class com.github.hluk.copyq"
            "size 400 400, match:class com.github.hluk.copyq"

            # Sharing zen-twilight
            "float on, match:class zen-twilight, match:title Sharing Indicator — Zen Twilight"
            "suppress_event fullscreen maximize activate activatefocus, match:class zen-twilight, match:title Sharing Indicator — Zen Twilight"
            "size 55 32, match:class zen-twilight, match:title Sharing Indicator — Zen Twilight"
            "move 5 1400, match:class zen-twilight, match:title Sharing Indicator — Zen Twilight"

            # Videos - force opaque
            "opaque on, match:class zen-twilight, match:title YouTube"
            "opaque on, match:class zen-twilight, match:title Prime Video"
          ];
        };
      };

      # Auto-start Hyprland on tty1
      programs.bash.profileExtra = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          exec uwsm start hyprland-uwsm.desktop
        fi
      '';

      catppuccin.hyprland = {
        enable = true;
        accent = "mauve";
        flavor = "mocha";
      };

      home.packages = with pkgs; [
        libnotify
        swww
        playerctl
        grimblast
        swappy
        wl-clipboard
      ];

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
    };
}
