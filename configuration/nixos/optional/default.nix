{
  gaming = import ./gaming.nix;
  hyprlock = import ./hyprlock.nix;
  hardware = {
    nvidia = import ./hardware/nvidia.nix;
    amd = import ./hardware/amd.nix;
  };
  programs = {
    docker = import ./programs/docker.nix;
    podman = import ./programs/podman.nix;
  };
}
