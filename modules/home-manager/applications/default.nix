{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ysomic.applications.defaults;

  terminalPackage = config.ysomic.applications.defaults.supported.terminals.${cfg.terminal};
  fileManagerPackage = config.ysomic.applications.defaults.supported.fileManagers.${cfg.fileManager};
  getDesktopFile = app: let
    pname = app.pname or null;
    mainProgram = app.meta.mainProgram or null;
    name = app.name or null;

    # Extract basename from name if it contains derivation info
    extractBaseName = fullName:
      if fullName != null
      then builtins.head (lib.splitString "-" fullName)
      else null;

    desktopName =
      if pname != null
      then pname
      else if mainProgram != null
      then mainProgram
      else if name != null
      then extractBaseName name
      else throw "Package ${app} has no pname, mainProgram, or name attribute";
  in "${desktopName}.desktop";
in {
  imports = [
    ./rofi.nix
  ];

  options.ysomic.applications.defaults = {
    enable = lib.mkEnableOption "Default application configuration";

    # Helpers for other modules
    supported.terminals = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      default = {
        kitty = pkgs.kitty;
      };
    };

    # Core applications
    browser = lib.mkOption {
      type = lib.types.package;
      default = pkgs.floorp;
      description = "Default web browser";
    };

    terminal = lib.mkOption {
      type = lib.types.enum (builtins.attrNames config.ysomic.applications.defaults.supported.terminals);
      default = "kitty";
      description = ''
        Default terminal emulator.
        Supported values: ${builtins.concatStringsSep ", " (builtins.attrNames config.ysomic.applications.defaults.supported.terminals)}
      '';
    };

    pdfReader = lib.mkOption {
      type = lib.types.package;
      default = pkgs.zathura;
      description = "Default PDF reader";
    };

    webImages = lib.mkOption {
      type = lib.types.package;
      default = cfg.browser;
      description = "Default viewer for web images (gif, svg, webp)";
    };

    imageViewer = lib.mkOption {
      type = lib.types.package;
      default = pkgs.imv;
      description = "Default image viewer (jpg, png, bmp)";
    };

    videoPlayer = lib.mkOption {
      type = lib.types.package;
      default = (
        if config.programs.mpv.enable
        then config.programs.mpv.finalPackage
        else pkgs.vlc
      );
      description = "Default video player";
    };

    audioPlayer = lib.mkOption {
      type = lib.types.package;
      default = (
        if config.programs.mpv.enable
        then config.programs.mpv.finalPackage
        else pkgs.vlc
      );
      description = "Default audio player";
    };

    # Additional options
    associations = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = {};
      description = "Additional mime type associations";
      example = lib.literalExpression ''
        {
          "text/plain" = [ "org.gnome.gedit.desktop" ];
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = [
        cfg.browser
        cfg.pdfReader
        cfg.webImages
        cfg.imageViewer
        cfg.videoPlayer
        cfg.audioPlayer
      ];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = lib.mkMerge [
          # Web browser associations
          {
            "x-scheme-handler/http" = [(getDesktopFile cfg.browser)];
            "x-scheme-handler/https" = [(getDesktopFile cfg.browser)];
            "x-scheme-handler/chrome" = [(getDesktopFile cfg.browser)];
            "text/html" = [(getDesktopFile cfg.browser)];
            "application/x-extension-htm" = [(getDesktopFile cfg.browser)];
            "application/x-extension-html" = [(getDesktopFile cfg.browser)];
            "application/x-extension-shtml" = [(getDesktopFile cfg.browser)];
            "application/xhtml+xml" = [(getDesktopFile cfg.browser)];
            "application/x-extension-xhtml" = [(getDesktopFile cfg.browser)];
            "application/x-extension-xht" = [(getDesktopFile cfg.browser)];
          }
          # PDF associations
          {
            "application/pdf" = [
              (getDesktopFile cfg.pdfReader)
              (getDesktopFile cfg.browser)
            ];
          }
          # File manager associations
          {
            "inode/directory" = [(getDesktopFile fileManagerPackage)];
            "application/x-compressed-tar" = [(getDesktopFile fileManagerPackage)];
          }
          # Web image associations
          {
            "image/gif" = [(getDesktopFile cfg.webImages)];
            "image/svg+xml" = [(getDesktopFile cfg.webImages)];
            "image/webp" = [(getDesktopFile cfg.webImages)];
          }
          # Regular image associations
          {
            "image/jpeg" = [(getDesktopFile cfg.imageViewer)];
            "image/jpg" = [(getDesktopFile cfg.imageViewer)];
            "image/png" = [(getDesktopFile cfg.imageViewer)];
            "image/bmp" = [(getDesktopFile cfg.imageViewer)];
            "image/tiff" = [(getDesktopFile cfg.imageViewer)];
          }
          # Video associations
          {
            "video/mp4" = [(getDesktopFile cfg.videoPlayer)];
            "video/mpeg" = [(getDesktopFile cfg.videoPlayer)];
            "video/webm" = [(getDesktopFile cfg.videoPlayer)];
            "video/ogg" = [(getDesktopFile cfg.videoPlayer)];
            "video/quicktime" = [(getDesktopFile cfg.videoPlayer)]; # .mov
            "video/x-matroska" = [(getDesktopFile cfg.videoPlayer)]; # .mkv
            "video/x-msvideo" = [(getDesktopFile cfg.videoPlayer)]; #.avi
          }
          # Audio associations
          {
            "audio/mpeg" = [(getDesktopFile cfg.audioPlayer)];
            "audio/mp3" = [(getDesktopFile cfg.audioPlayer)];
            "audio/mp4" = [(getDesktopFile cfg.audioPlayer)]; #.m4a
            "audio/webm" = [(getDesktopFile cfg.audioPlayer)];
            "audio/aac" = [(getDesktopFile cfg.audioPlayer)];
            "audio/ogg" = [(getDesktopFile cfg.audioPlayer)];
            "audio/flac" = [(getDesktopFile cfg.audioPlayer)];
            "audio/wav" = [(getDesktopFile cfg.audioPlayer)];
          }
          cfg.associations
        ];
      };

      # Export environment variables
      home.sessionVariables = {
        BROWSER = lib.getExe cfg.browser;
        TERMINAL = lib.getExe terminalPackage;
        FILE_MANAGER = lib.getExe fileManagerPackage;
      };
    }

    ## TERMINALS
    (lib.mkIf (cfg.terminal == "kitty") {
      xdg.desktopEntries = {
        kitty-safe = {
          name = "Kitty (Safe Mode)";
          comment = "Terminal without bash profile";
          exec = "kitty bash --noprofile --norc";
          icon = "kitty";
          terminal = false;
          categories = ["System" "TerminalEmulator"];
        };

        kitty-sh = {
          name = "Kitty (Basic Shell)";
          comment = "Terminal with basic POSIX shell";
          exec = "kitty sh";
          icon = "kitty";
          terminal = false;
          categories = ["System" "TerminalEmulator"];
        };

        kitty-emergency = {
          name = "Kitty (Emergency Terminal)";
          comment = "Clean environment for system recovery";
          exec = "kitty env -i bash --noprofile --norc";
          icon = "applications-system";
          terminal = false;
          categories = ["System"];
        };
      };

      programs.kitty = {
        enable = true;
        font.name = "JetBrainsMono Nerd Font";
        font.size = 12;
        shellIntegration.enableBashIntegration = true;
        settings = {
          # Seems to be crashing hyprland sometimes
          # cursor_trail = 4;
          window_title = "{title} - Kitty";
          tab_bar_min_tabs = 1;
          tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
          tab_bar_edge = "bottom";
          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";
          enable_audio_bell = false;
          scrollback_lines = 10000;
          disable_ligatures = "never";

          symbol_map = "U+1F300-U+1F9FF Noto Color Emoji"; # Emoji range
          font_features = "none";
        };
      };
    })
  ]);
}
