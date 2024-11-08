{
  description = "ySomic's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    #Personal NIXVIM
    yvim = {
      url = "github:mathieudr/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./hosts
        ./home-manager
        # ./modules
        ./pre-commit-hooks.nix
      ];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.git
            pkgs.nodePackages.prettier
            config.packages.repl
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
#   outputs = {
#     self,
#     nixpkgs,
#     home-manager,
#     ...
#   } @ inputs: let
#     inherit (self) outputs;
#   in {
#     nixosConfigurations = {
#       "anchor" = nixpkgs.lib.nixosSystem {
#         specialArgs = {inherit inputs;};
#         modules = [
#           ./configuration.nix
#         ];
#       };
#
#       "wanderer" = nixpkgs.lib.nixosSystem {
#         specialArgs = {inherit inputs;};
#         modules = [];
#       };
#     };
#
#     homeConfigurations = {
#       "thieu@anchor" = home-manager.lib.homeManagerConfiguration {
#         pkgs = nixpkgs.legacyPackages.x86_64-linux;
#         extraSpecialArgs = {
#           inherit inputs outputs;
#         };
#         modules = [
#           inputs.catppuccin.homeManagerModules.catppuccin
#           ./home.nix
#         ];
#       };
#
#       "mathieu@wanderer" = home-manager.lib.homeManagerConfiguration {
#         pkgs = nixpkgs.legacyPackages.x86_64-linux;
#         extraSpecialArgs = {
#           inherit inputs;
#         };
#         modules = [
#           inputs.catppuccin.homeManagerModules.catppuccin
#           ./home.nix
#         ];
#       };
#     };
#   };
# }
