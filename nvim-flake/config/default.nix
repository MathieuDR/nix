{ lexicalPackage, ... }:
{
  imports = [
    ./base.nix
    ./helpers.nix
    (import ./lsp.nix { inherit lexicalPackage; })
    ./git.nix
    ./whichkey.nix
    ./fs.nix
    ./no-config-plugins.nix
    ./telescope.nix
    ./trouble.nix
    ./ufo.nix
    ./keymaps.nix
    ./layout.nix
  ];
}
