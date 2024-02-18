{
  description = "NeoVim configuration using Nixvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    lexical.url = "github:lexical-lsp/lexical";
  };

  outputs =
    { nixpkgs
    , nixvim
    , lexical
    , flake-parts
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        { pkgs
        , system
        , ...
        }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          lexicalPackage = lexical.packages.${system}.default;
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = import ./config { inherit lexicalPackage pkgs; };
          };
        in
        {
          packages = {
            # Lets you run `nix run .` to start nixvim
            default = nvim;
            inherit lexicalPackage;
          };

          formatter = pkgs.alejandra;

          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNvim {
              inherit nvim;
              name = "A nixvim configuration";
            };
          };
        };
    };
}
