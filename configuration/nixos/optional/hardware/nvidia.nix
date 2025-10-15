{
  pkgs,
  config,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
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

  # For hyprland
  environment.systemPackages = with pkgs; [
    egl-wayland
  ];
}
