{...}: {
  imports = [
    ../shared
    ./unfree.nix
    ./applications
    ./gc/profile-gc.nix
    ./hardware/nvidia.nix
    ./wayland/hyprland
  ];
}
