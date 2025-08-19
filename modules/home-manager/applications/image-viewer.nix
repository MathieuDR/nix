{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.ysomic.applications.imageViewer;

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
  options.ysomic.applications.imageViewer = {
    enable = mkEnableOption "image viewer configuration";

    package = mkOption {
      type = types.package;
      default = pkgs.imv;
      description = "Image viewer package to use";
    };

    handleWebImages = mkOption {
      type = types.bool;
      default = false;
      description = "Handle web image formats (gif, svg, webp) - usually better handled by browser";
    };

    setAsDefault = mkOption {
      type = types.bool;
      default = true;
      description = "Set as default image viewer for MIME associations";
    };

    imageFormats = mkOption {
      type = types.listOf types.str;
      default = [
        "image/jpeg"
        "image/jpg"
        "image/png"
        "image/bmp"
        "image/tiff"
      ];
      description = "Image MIME types to associate with this viewer";
    };

    webImageFormats = mkOption {
      type = types.listOf types.str;
      default = [
        "image/gif"
        "image/svg+xml"
        "image/webp"
      ];
      description = "Web image MIME types to associate with this viewer";
    };

    additionalAssociations = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {};
      description = "Additional MIME type associations for the image viewer";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.mimeApps = mkIf cfg.setAsDefault {
      enable = true;
      defaultApplications = mkMerge [
        # Regular image formats
        (listToAttrs (map (format: {
            name = format;
            value = [(getDesktopFile cfg.package)];
          })
          cfg.imageFormats))

        # Web image formats (if enabled)
        (mkIf cfg.handleWebImages
          (listToAttrs (map (format: {
              name = format;
              value = [(getDesktopFile cfg.package)];
            })
            cfg.webImageFormats)))

        cfg.additionalAssociations
      ];
    };
  };
}
