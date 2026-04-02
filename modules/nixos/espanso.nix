{...}: {
  flake.modules.nixos.espanso = {pkgs, ...}: {
    services.espanso = {
      enable = true;
      package = pkgs.espanso-wayland;
    };

    # uinput/input groups are required for espanso to capture keyboard input
    users.users.thieu.extraGroups = ["input" "uinput"];
  };
}
