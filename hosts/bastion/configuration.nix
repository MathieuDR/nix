{...}: {
  # For emulating aarch64
  # Needed for ?? CA / caddy?
  # binfmt.emulatedSystems = ["aarch64-linux"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.05"; # Did you read the comment?
}
