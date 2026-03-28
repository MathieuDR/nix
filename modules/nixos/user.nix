{...}: {
  flake.modules.nixos.user = {
    users.users.thieu = {
      isNormalUser = true;
      description = "Mathieu De Raedt";
      extraGroups = [
        "networkmanager"
        "wheel"
        # Scanner & lp for scanning
        "scanner"
        "lp"
      ];
    };

    services.getty.autologinUser = "thieu";
  };
}
