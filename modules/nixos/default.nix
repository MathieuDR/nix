{...}: {
  imports = [
    ../shared
    ./unfree.nix
    ./hardware/nvidia.nix
    ./wayland/hyprland
  ];
}
