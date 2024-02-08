{ lexicalPackage, ... }:
{
  imports = [
    ./base.nix
    ./helpers.nix
    (import ./lsp.nix { inherit lexicalPackage; })
    ./git.nix
    ./no-config-plugins.nix
    ./telescope.nix
    ./trouble.nix
    ./layout.nix
  ];
}
