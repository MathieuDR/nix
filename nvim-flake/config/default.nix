{ lexicalPackage, ... }:
{
  imports = [
    ./base.nix
    ./helpers.nix
    (import ./lsp.nix { inherit lexicalPackage; })
    ./git.nix
    ./fs.nix
    ./no-config-plugins.nix
    ./telescope.nix
    ./trouble.nix
    ./whichkey.nix
    ./keymaps.nix
    ./layout.nix
  ];
}
