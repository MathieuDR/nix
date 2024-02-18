{ lexicalPackage, pkgs, ... }:
{
  imports = [
    ./base.nix
    ./keymaps.nix
    ./helpers.nix
    (import ./lsp.nix { inherit lexicalPackage; })
    (import ./custom-packages.nix { inherit pkgs; })
    ./git.nix
    ./whichkey.nix
    ./fs.nix
    ./comments.nix
    ./telescope.nix
    ./trouble.nix
    ./ufo.nix
    ./layout.nix
  ];
}
