{...}: {
  imports = [
    ./hardware.nix
    ./applications
    ./wayland/hyprland.nix
  ];
}
