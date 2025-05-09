{pkgs, ...}: {
  imports = [
    ./networking.nix
    ./common-packages.nix
    ./security.nix
    ./sound.nix
    ./user.nix
    ./auto-cleanup.nix
  ];

  boot.loader.systemd-boot.configurationLimit = 15;
  hardware.graphics.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_BE.UTF-8";
    LC_IDENTIFICATION = "nl_BE.UTF-8";
    LC_MEASUREMENT = "nl_BE.UTF-8";
    LC_MONETARY = "nl_BE.UTF-8";
    LC_NAME = "nl_BE.UTF-8";
    LC_NUMERIC = "nl_BE.UTF-8";
    LC_PAPER = "nl_BE.UTF-8";
    LC_TELEPHONE = "nl_BE.UTF-8";
    LC_TIME = "nl_BE.UTF-8";
  };
  console = {
    useXkbConfig = true;
  };

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "intl";
  };

  # Automounting usb
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # espanso
  services.espanso = {
    enable = true;
  };

  #Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # Show battery level
  };
}
