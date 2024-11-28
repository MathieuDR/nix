{
  config,
  lib,
  ...
}: let
  cfg = config.ysomic.applications.defaults;
in {
  config = lib.mkIf (cfg.enable && cfg.fileManager == "thunar") {
    programs.thunar = {
      enable = true;
      plugins = cfg.fileManagerPlugins;
    };
  };
}
