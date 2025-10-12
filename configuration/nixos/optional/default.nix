{
  gaming = import ./gaming.nix;
  hyprlock = import ./hyprlock.nix;
  hardware = {
    nvidia = import ./hardwar/nvidia.nix;
    amd = import ./hardwar/amd.nix;
  };
  programs = {
    docker = import ./programs/docker.nix;
  };
}
