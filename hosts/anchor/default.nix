{self, ...}: let
  dir = "${self}/configuration";
in {
  imports = [
    ./configuration.nix
    "${dir}/gaming.nix"
  ];
}
