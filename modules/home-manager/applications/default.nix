{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ysomic.applications.defaults;

  terminalPackage = config.ysomic.applications.defaults.supported.terminals.${cfg.terminal};
  fileManagerPackage = config.ysomic.applications.defaults.supported.fileManagers.${cfg.fileManager};
  getDesktopFile = app: "${app}.desktop";
in {
  options.ysomic.applications.defaults = {
    enable = lib.mkEnableOption "Default application configuration";

    # Helpers for other modules
    supported = lib.mkOption {
      type = lib.types.attrs;
      # Won't show up in documentation
      internal = true;
      default = {
        terminals = {
          kitty = pkgs.kitty;
        };
        fileManagers = {
          thunar = pkgs.xfce.thunar;
        };
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

    fileManager = lib.mkOption {
      type = lib.types.enum (builtins.attrNames config.ysomic.applications.defaults.supported.fileManagers);
      default = "thunar";
      description = ''
        Default file manager.
        Supported values: ${builtins.concatStringsSep ", " (builtins.attrNames config.ysomic.applications.defaults.supported.fileManagers)}
      '';
    };

    fileManagerPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
      description = "Plugins to enable for the filemanager, for example Thunar";
    };

    pdfReader = lib.mkOption {
      type = lib.types.package;
      default = pkgs.okular;
      description = "Default PDF reader";
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
      ];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = lib.mkMerge [
          {
            "x-scheme-handler/http" = [(getDesktopFile cfg.browser.pname)];
            "x-scheme-handler/https" = [(getDesktopFile cfg.browser.pname)];
            "x-scheme-handler/chrome" = [(getDesktopFile cfg.browser.pname)];
            "text/html" = [(getDesktopFile cfg.browser.pname)];
            "application/x-extension-htm" = [(getDesktopFile cfg.browser.pname)];
            "application/x-extension-html" = [(getDesktopFile cfg.browser.pname)];
            "application/x-extension-shtml" = [(getDesktopFile cfg.browser.pname)];
            "application/xhtml+xml" = [(getDesktopFile cfg.browser.pname)];
            "application/x-extension-xhtml" = [(getDesktopFile cfg.browser.pname)];
            "application/x-extension-xht" = [(getDesktopFile cfg.browser.pname)];
          }
          {
            "application/pdf" = [
              (getDesktopFile cfg.pdfReader.pname)
              (getDesktopFile cfg.browser.pname)
            ];
          }
          {
            "inode/directory" = [(getDesktopFile fileManagerPackage.pname)];
            "application/x-compressed-tar" = [(getDesktopFile fileManagerPackage.pname)];
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

    ## FILE MANAGERS
    (lib.mkIf (cfg.fileManager == "thunar") {
      programs.thunar.enable = true;
      programs.thunar.plugins = cfg.fileManagerPlugins;
    })

    ## TERMINALS
    (lib.mkIf (cfg.terminal == "kitty") {
      programs.kitty = {
        enable = true;
        font.name = "JetBrainsMono Nerd Font";
        font.size = 12;
        settings = {
          tab_bar_min_tabs = 1;
          tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
          tab_bar_edge = "bottom";
          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";
          enable_audio_bell = false;
          scrollback_lines = 10000;
          disable_ligatures = "never";
        };
      };
    })
  ]);
}
