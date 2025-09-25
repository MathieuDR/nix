{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.ysomic.applications.browser;

  getDesktopFile = app: let
    pname = app.pname or null;
    mainProgram = app.meta.mainProgram or null;
    name = app.name or null;

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
  options.ysomic.applications.browser = {
    enable = mkEnableOption "browser configuration";

    package = mkOption {
      type = types.package;
      default = pkgs.floorp-bin;
      description = "Browser package to use";
    };

    setAsDefault = mkOption {
      type = types.bool;
      default = true;
      description = "Set as default browser for MIME associations";
    };

    setEnvironmentVariable = mkOption {
      type = types.bool;
      default = true;
      description = "Set BROWSER environment variable";
    };

    additionalAssociations = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {};
      description = "Additional MIME type associations for the browser";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    home.sessionVariables = mkIf cfg.setEnvironmentVariable {
      BROWSER = getExe cfg.package;
    };

    xdg.mimeApps = mkIf cfg.setAsDefault {
      enable = true;
      defaultApplications = mkMerge [
        {
          "x-scheme-handler/http" = [(getDesktopFile cfg.package)];
          "x-scheme-handler/https" = [(getDesktopFile cfg.package)];
          "x-scheme-handler/chrome" = [(getDesktopFile cfg.package)];
          "text/html" = [(getDesktopFile cfg.package)];
          "application/x-extension-htm" = [(getDesktopFile cfg.package)];
          "application/x-extension-html" = [(getDesktopFile cfg.package)];
          "application/x-extension-shtml" = [(getDesktopFile cfg.package)];
          "application/xhtml+xml" = [(getDesktopFile cfg.package)];
          "application/x-extension-xhtml" = [(getDesktopFile cfg.package)];
          "application/x-extension-xht" = [(getDesktopFile cfg.package)];
        }
        cfg.additionalAssociations
      ];
    };
  };
}
