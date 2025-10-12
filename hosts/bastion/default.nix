{self, ...}: let
  optional = (import "${self}/configuration").nixos.optional;
in {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    optional.hardware.amd
    # optional.gaming
    # optional.programs.onepassword
    # optional.programs.docker
    # optional.wake-up
  ];
}
