{
  config,
  lib,
  pkgs,
  isDarwin,
  ...
}:
with lib; let
  cfg = config.ysomic.applications.terminal;
in {
  options.ysomic.applications.terminal = {
    enable = mkEnableOption "terminal configuration";

    type = mkOption {
      type = types.enum ["kitty"];
      default = "kitty";
      description = "Terminal type to configure";
    };

    setEnvironmentVariable = mkOption {
      type = types.bool;
      default = true;
      description = "Set TERMINAL environment variable";
    };

    kitty = {
      fontSize = mkOption {
        type = types.int;
        default = 12;
        description = "Font size for kitty";
      };

      fontName = mkOption {
        type = types.str;
        default = "JetBrainsMono Nerd Font";
        description = "Font name for kitty";
      };

      scrollbackLines = mkOption {
        type = types.int;
        default = 10000;
        description = "Number of scrollback lines";
      };

      extraSettings = mkOption {
        type = types.attrsOf types.anything;
        default = {};
        description = "Additional kitty settings";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.sessionVariables = mkIf cfg.setEnvironmentVariable {
        TERMINAL = mkIf (cfg.type == "kitty") (getExe pkgs.kitty);
      };
    }

    (mkIf (cfg.type == "kitty") {
      # xdg.desktopEntries = {
      #   kitty-safe = {
      #     name = "Kitty (Safe Mode)";
      #     comment = "Terminal without bash profile";
      #     exec = "kitty bash --noprofile --norc";
      #     icon = "kitty";
      #     terminal = false;
      #     categories = ["System" "TerminalEmulator"];
      #   };
      #
      #   kitty-sh = {
      #     name = "Kitty (Basic Shell)";
      #     comment = "Terminal with basic POSIX shell";
      #     exec = "kitty sh";
      #     icon = "kitty";
      #     terminal = false;
      #     categories = ["System" "TerminalEmulator"];
      #   };
      #
      #   kitty-emergency = {
      #     name = "Kitty (Emergency Terminal)";
      #     comment = "Clean environment for system recovery";
      #     exec = "kitty env -i bash --noprofile --norc";
      #     icon = "applications-system";
      #     terminal = false;
      #     categories = ["System"];
      #   };
      # };
      #
      programs.kitty = {
        enable = true;
        font.name = cfg.kitty.fontName;
        font.size = cfg.kitty.fontSize;
        shellIntegration.enableBashIntegration = true;
        settings = mkMerge [
          {
            window_title = "{title} - Kitty";
            tab_bar_min_tabs = 1;
            tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
            tab_bar_edge = "bottom";
            tab_bar_style = "powerline";
            tab_powerline_style = "slanted";
            enable_audio_bell = false;
            scrollback_lines = cfg.kitty.scrollbackLines;
            disable_ligatures = "never";
            symbol_map = "U+1F300-U+1F9FF Noto Color Emoji";
            font_features = "none";
          }
          # (mkIf isDarwin {
          #   kitty_mod = "super+shift";
          #   "map cmd+r" = "no_op"; # Disable cmd+r
          #   "map ctrl+r" = "start_resizing_window"; # Remap to ctrl+r
          # })
          cfg.kitty.extraSettings
        ];
      };
    })
  ]);
}
