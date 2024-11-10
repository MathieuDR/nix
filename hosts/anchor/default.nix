{self, ...}: let
  opt = "${self}/configuration/optional";
in {
  imports = [
    ./configuration.nix
    "${opt}/gaming.nix"
    "${opt}/programs/1password.nix"
    "${opt}/programs/docker.nix"
    "${opt}/programs/thunar.nix"
  ];
}
