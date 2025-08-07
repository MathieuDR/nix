{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.ysomic.applications.mediaPlayer;

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

  defaultPackage =
    if config.programs.mpv.enable
    then config.programs.mpv.finalPackage
    else pkgs.vlc;
in {
  options.ysomic.applications.mediaPlayer = {
    enable = mkEnableOption "media player configuration";

    package = mkOption {
      type = types.package;
      default = defaultPackage;
      description = "Media player package to use (defaults to mpv if enabled, otherwise vlc)";
    };

    handleVideo = mkOption {
      type = types.bool;
      default = true;
      description = "Handle video file associations";
    };

    handleAudio = mkOption {
      type = types.bool;
      default = true;
      description = "Handle audio file associations";
    };

    setAsDefault = mkOption {
      type = types.bool;
      default = true;
      description = "Set as default media player for MIME associations";
    };

    videoFormats = mkOption {
      type = types.listOf types.str;
      default = [
        "video/mp4"
        "video/mpeg"
        "video/webm"
        "video/ogg"
        "video/quicktime" # .mov
        "video/x-matroska" # .mkv
        "video/x-msvideo" # .avi
      ];
      description = "Video MIME types to associate with this player";
    };

    audioFormats = mkOption {
      type = types.listOf types.str;
      default = [
        "audio/mpeg"
        "audio/mp3"
        "audio/mp4" # .m4a
        "audio/webm"
        "audio/aac"
        "audio/ogg"
        "audio/flac"
        "audio/wav"
      ];
      description = "Audio MIME types to associate with this player";
    };

    additionalAssociations = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {};
      description = "Additional MIME type associations for the media player";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.mimeApps = mkIf cfg.setAsDefault {
      enable = true;
      defaultApplications = mkMerge [
        # Video formats
        (mkIf cfg.handleVideo
          (listToAttrs (map (format: {
              name = format;
              value = [(getDesktopFile cfg.package)];
            })
            cfg.videoFormats)))

        # Audio formats
        (mkIf cfg.handleAudio
          (listToAttrs (map (format: {
              name = format;
              value = [(getDesktopFile cfg.package)];
            })
            cfg.audioFormats)))

        cfg.additionalAssociations
      ];
    };
  };
}
