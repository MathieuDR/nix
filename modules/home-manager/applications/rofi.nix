{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.ysomic.applications.rofi;
in {
  options.ysomic.applications.rofi = {
    enable = mkEnableOption "ysomic rofi configuration";

    package = mkOption {
      type = types.package;
      default = pkgs.rofi-wayland;
      description = "The rofi package to use";
    };

    plugins = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        rofi-calc
      ];
      description = "List of rofi plugins to install";
    };

    powerMenu = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable the power menu integration";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = cfg.package;
      plugins = cfg.plugins;
    };

    home.packages = cfg.extraPackages;

    ysomic.power.menu = mkIf cfg.powerMenu.enable {
      enable = true;
      launcherPackage = cfg.package;
    };
  };
}
