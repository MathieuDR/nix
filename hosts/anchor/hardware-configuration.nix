# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b6283a99-a71c-48da-96a9-31eaab76582e";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b6283a99-a71c-48da-96a9-31eaab76582e";
    fsType = "btrfs";
    options = ["subvol=@home"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/b6283a99-a71c-48da-96a9-31eaab76582e";
    fsType = "btrfs";
    options = ["subvol=@nix"];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/b6283a99-a71c-48da-96a9-31eaab76582e";
    fsType = "btrfs";
    options = ["subvol=@log"];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/b6283a99-a71c-48da-96a9-31eaab76582e";
    fsType = "btrfs";
    options = ["subvol=@snapshots"];
  };

  fileSystems."/tmp" = {
    device = "/dev/disk/by-uuid/b6283a99-a71c-48da-96a9-31eaab76582e";
    fsType = "btrfs";
    options = ["subvol=@tmp"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D901-7589";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/85a1ff1a-4132-474d-aae1-800f8e06f464";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp9s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp6s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
