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
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [
            self.overlays.default
            inputs.nur.overlays.default
          ];
        };

        extraSpecialArgs = {
          inherit inputs self user hostname;
          nixosConfig = self.nixosConfigurations.${hostname}.config;
          nixpkgs = inputs.nixpkgs;
        };

        modules = [
          self.homeManagerModules.default
          inputs.agenix.homeManagerModules.default
          inputs.catppuccin.homeModules.catppuccin
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
