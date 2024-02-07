{ lexicalPackage, ... }:
{
  imports = [
    ./base.nix
    ./helpers.nix
    (import ./lsp.nix { inherit lexicalPackage; })
    ./git.nix
    ./telescope.nix
    ./trouble.nix
    ./layout.nix
  ];
}
