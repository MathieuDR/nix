{
  lib,
  config,
  ...
}: let
  cfg = config.ysomic.hardware.nvidia;
in {
  config = lib.mkIf cfg.enable {
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    allowedUnfree = [
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
