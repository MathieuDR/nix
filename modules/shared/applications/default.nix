{
  lib,
  pkgs,
  config,
  ...
}: {
  options.ysomic.applications.defaults = {
    supported.fileManagers = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      default = {
        "thunar" = pkgs.thunar;
      };
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
      default = with pkgs; [
        thunar-archive-plugin
        thunar-volman
        tumbler
      ];
      description = "Plugins to enable for the filemanager, for example Thunar";
    };
  };
}
