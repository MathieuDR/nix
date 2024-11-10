{
  lib,
  config,
  ...
}: let
  cfg = config.ysomic.hardware.nvidia;
in {
  config = {
    hardware.nvidia = lib.mkIf cfg.enable {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "libXNVCtrl" # nvidia
      ];

    # enables nvidia drivers in xorg and wayland
    services.xserver = {
      videoDrivers = ["nvidia"];
    };
  };
}
