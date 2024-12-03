{self, ...}: let
  optional = (import "${self}/configuration").nixos.optional;
in {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    optional.programs.onepassword
    optional.programs.docker
  ];
}
