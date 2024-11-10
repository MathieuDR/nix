{self, ...}: let
  config = import "${self}/configuration";
in {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    config.nixos.optional.gaming
    config.nixos.optional.programs.onepassword
    config.nixos.optional.programs.docker
    config.nixos.optional.programs.thunar
  ];
}
