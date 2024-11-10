{self, ...}: let
  opt = "${self}/configuration/optional";
in {
  imports = [
    ./configuration.nix
    "${opt}/gaming.nix"
  ];
}
