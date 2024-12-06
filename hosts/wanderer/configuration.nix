{pkgs, ...}: {
  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  ysomic.applications.defaults.fileManager = "thunar";
  ysomic.wayland.hyprland = {
    enable = true;
    hyprlock.enable = true;
  };

  # Laptop stuff
  # Letting it on when it's closed but on external power
  services.logind.lidSwitchDocked = "ignore";

  # AMD
  # https://wiki.nixos.org/wiki/AMD_GPU

  # Enable networking
  networking.networkmanager.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
