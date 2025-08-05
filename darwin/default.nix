{
  self,
  inputs,
  ...
}: {
  flake.darwinConfigurations = let
    # shorten paths
    inherit (inputs.darwin.lib) darwinSystem;
    config = import "${self}/configuration";

    mkDarwin = {
      hostname,
      user,
      system,
    }:
      darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs self hostname user;
        };
        modules = [
          {
            nixpkgs.overlays = [
              self.overlays.default
            ];
          }

          self.darwinModules.default or {}
          config.darwin.shared or {}
          ./${hostname}

          # home manager integration
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs self user hostname;
              darwinConfig = config; # Pass Darwin config to home-manager
            };
            home-manager.users.${user} = import "${self}/home-manager/${hostname}";
          }
        ];
      };
  in {
    imposter = mkDarwin {
      hostname = "imposter";
      user = "thieu";
      system = "aarch64-darwin";
    };
  };
}
