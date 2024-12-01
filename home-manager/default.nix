{
  self,
  inputs,
  ...
}: {
  flake.homeConfigurations = let
    inherit (inputs.home-manager.lib) homeManagerConfiguration;
    config = import "${self}/configuration";
    extraSpecialArgs = {
      inherit inputs self;
      nixpkgs = inputs.nixpkgs;
    };
  in {
    "thieu@anchor" = homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      inherit extraSpecialArgs;
      modules = [
        self.homeManagerModules.default
        inputs.agenix.homeManagerModules.default
        inputs.catppuccin.homeManagerModules.catppuccin
        config.home-manager.shared
        ./anchor
      ];
    };
  };
}
