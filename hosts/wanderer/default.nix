{self, ...}: let
  optional = (import "${self}/configuration").nixos.optional;
in {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./thinkfan.nix
    optional.programs.onepassword
    optional.programs.docker
    # optional.power-management
    optional.wake-up
  ];
}
