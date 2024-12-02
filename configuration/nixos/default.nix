{
  imports = [
    ./networking.nix
    ./common-packages.nix
    ./security.nix
    ./sound.nix
    ./user.nix
    ./auto-cleanup.nix
  ];

  # I imagine this is common...
  hardware.graphics.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_GB.UTF-8";
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

  #Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # Show battery level
  };
}
