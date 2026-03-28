{...}: {
  flake.modules.nixos.base = {
    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 15;
    boot.loader.efi.canTouchEfiVariables = true;

    # For emulating aarch64 (Raspberry Pi, home server)
    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    # Hardware
    hardware.graphics.enable = true;

    # Nix
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;

    # System state
    system.stateVersion = "25.05";

    # Localization
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

    console.useXkbConfig = true;
    services.xserver.xkb.layout = "us";
    services.xserver.xkb.variant = "intl";
  };
}
