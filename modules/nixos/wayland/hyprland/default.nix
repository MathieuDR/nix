{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.ysomic.wayland.hyprland;
  nvidia = config.ysomic.hardware.nvidia;
in {
  config = lib.mkMerge [
    #Hyprland
    (lib.mkIf cfg.enable {
      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages."${pkgs.system}".hyprland;
        xwayland.enable = true;
      };
      services.displayManager.sddm.wayland.enable = true;
      services.xserver.enable = false;
    })

    #Hyprlock
    (lib.mkIf (cfg.enable && cfg.hyprlock.enable) {
      security.pam.services.hyprlock = {};
    })

    #Nvidia wayland package
    (lib.mkIf (cfg.enable && nvidia.enable) {
      environment.systemPackages = with pkgs; [
        egl-wayland
      ];
    })
  ];
}
