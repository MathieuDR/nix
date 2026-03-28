{...}: {
  flake.modules.nixos.services = {pkgs, ...}: {
    # Espanso text expander (system service)
    services.espanso = {
      enable = true;
      package = pkgs.espanso-wayland;
    };

    # SSH daemon
    services.openssh.enable = true;

    # USB automounting
    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    # Printing
    services.printing.enable = true;

    # Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true; # Show battery level
    };

    # Scanning
    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.sane-backends];
    };
  };
}
