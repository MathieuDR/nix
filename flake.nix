{
  description = "ySomic's NixOS flake";

  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-compat.url = "github:edolstra/flake-compat";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    catppuccin.url = "github:catppuccin/nix";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fixes
    espanso-fix.url = "github:pitkling/nixpkgs/espanso-fix-capabilities-export";

    # Custom packages / tools
    yvim = {
      url = "github:mathieudr/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    highlight-exporter = {
      url = "github:MathieuDR/readdeck-highlight-exporter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # DARWIN
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];

      imports = [
        ./hosts
        ./darwin
        ./home-manager
        ./modules
        ./overlays
        ./pkgs
        ./pre-commit-hooks.nix
      ];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.git
            pkgs.just
            pkgs.fzf
            pkgs.nodePackages.prettier
            (inputs.agenix.packages.${system}.default)
          ];
          name = "dots";
          DIRENV_LOG_FORMAT = "";
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };

        formatter = pkgs.alejandra;
      };
    };
}
