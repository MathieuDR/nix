{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.ysomic.applications.pdfReader;

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
  options.ysomic.applications.pdfReader = {
    enable = mkEnableOption "PDF reader configuration";

    package = mkOption {
      type = types.package;
      default = pkgs.zathura;
      description = "PDF reader package to use";
    };

    setAsDefault = mkOption {
      type = types.bool;
      default = true;
      description = "Set as default PDF reader for MIME associations";
    };

    fallbackToBrowser = mkOption {
      type = types.bool;
      default = true;
      description = "Add browser as fallback for PDF files (requires browser module)";
    };

    additionalAssociations = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {};
      description = "Additional MIME type associations for the PDF reader";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.mimeApps = mkIf cfg.setAsDefault {
      enable = true;
      defaultApplications = mkMerge [
        {
          "application/pdf" =
            [
              (getDesktopFile cfg.package)
            ]
            ++ optional (cfg.fallbackToBrowser && config.ysomic.applications.browser.enable)
            (getDesktopFile config.ysomic.applications.browser.package);
        }
        cfg.additionalAssociations
      ];
    };
  };
}
