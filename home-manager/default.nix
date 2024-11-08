{
  self,
  nixpkgs,
  inputs,
  ...
}: {
  flake.homeConfiguration = let
    # shorten paths
    inherit (inputs.home-manager.lib) homeManagerConfiguration;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    "thieu@anchor" = homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      inherit specialArgs;
      modules = [
        inputs.catppuccin.homeManagerModules.catppuccin
        ./anchor
      ];
    };
  };
}
