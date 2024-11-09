{
  imports = [
    ./networking
    ./common-packages.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    #keyMap = "us-intl";
    useXkbConfig = true; # use xkb.options in tty.
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
