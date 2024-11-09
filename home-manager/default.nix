{
  self,
  inputs,
  ...
}: {
  flake.homeConfigurations = let
    inherit (inputs.home-manager.lib) homeManagerConfiguration;
    extraSpecialArgs = {
      inherit inputs self;
      nixpkgs = inputs.nixpkgs;
    };
  in {
    "thieu@anchor" = homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; # Use inputs.nixpkgs instead
      inherit extraSpecialArgs;
      modules = [
        inputs.catppuccin.homeManagerModules.catppuccin
        ./anchor
      ];
    };
  };
}
