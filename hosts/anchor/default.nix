{self, ...}: let
  optional = (import "${self}/configuration").nixos.optional;
in {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix

    optional.hardware.nvidia

    optional.gaming
    optional.programs.docker
  ];
}
