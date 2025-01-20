{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    binfmt.emulatedSystems = ["aarch64-linux"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  ysomic.hardware.nvidia.enable = true;
  ysomic.applications.defaults.fileManager = "thunar";
  ysomic.wayland.hyprland = {
    enable = true;
    hyprlock.enable = false;
  };

  networking = {
    wireless = {
      enable = true;
    };
  };

  system.stateVersion = "24.11";
}
