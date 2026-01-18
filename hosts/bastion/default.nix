{self, ...}: let
  optional = (import "${self}/configuration").nixos.optional;
in {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    optional.hardware.amd
    optional.hardware.wine
    optional.gaming
    optional.programs.podman
  ];
}
