{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    binfmt.emulatedSystems = ["aarch64-linux"];
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 1;

      systemd-boot = {
        enable = true;
        extraEntries = {
          "windows.conf" = ''
            title Windows
            efi /EFI/Microsoft/Boot/bootmgfw.efi
          '';
          "nixos-legacy.conf" = ''
            title NixOS (Legacy)
            linux /EFI/nixos-legacy/kernel
            initrd /EFI/nixos-legacy/initrd
            options root=UUID=d27768e7-437b-4436-aee5-ab4bd5c3a5e0 rw
          '';
        };
      };
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
