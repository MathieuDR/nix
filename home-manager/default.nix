{
  self,
  inputs,
  ...
}: {
  flake.homeConfigurations = let
    inherit (inputs.home-manager.lib) homeManagerConfiguration;
    config = import "${self}/configuration";

    mkHome = {
      user,
      hostname,
    }:
      homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

        extraSpecialArgs = {
          inherit inputs self user hostname;
          nixpkgs = inputs.nixpkgs;
        };

        modules = [
          self.homeManagerModules.default
          inputs.agenix.homeManagerModules.default
          inputs.catppuccin.homeManagerModules.catppuccin
          config.home-manager.shared
          ./${hostname}
        ];
      };
  in {
    "thieu@anchor" = mkHome {
      hostname = "anchor";
      user = "thieu";
    };
    "thieu@wanderer" = mkHome {
      hostname = "wanderer";
      user = "thieu";
    };
  };
}
