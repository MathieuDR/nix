{
  lib,
  config,
  ...
}: let
  cfg = config.ysomic.wayland.hyprland;
in {
  config =
    lib.mkIf cfg.enable {
    };
}
