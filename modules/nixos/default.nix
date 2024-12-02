{...}: {
  imports = [
    ../shared
    ./unfree.nix
    ./gc/profile-gc.nix
    ./hardware/nvidia.nix
    ./wayland/hyprland
  ];
}
