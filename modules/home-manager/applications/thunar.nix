{
  config,
  lib,
  ...
}: let
  cfg = config.ysomic.applications.defaults;
in {
  config = lib.mkIf (cfg.fileManager == "thunar") {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "thunar.desktop";
        "x-scheme-handler/file" = "thunar.desktop";
      };
    };
  };
}
