{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    config = import "${self}/configuration";
    mkSystem = {
      hostname,
      user,
    }:
      nixosSystem {
        specialArgs = {
          inherit inputs self hostname user;
        };
        modules = [
          {
            nixpkgs.overlays = [
              self.overlays.default
            ];
          }

          inputs.espanso-fix.nixosModules.espanso-capdacoverride
          inputs.agenix.nixosModules.default
          {
            nixpkgs.overlays = [
              inputs.nur.overlays.default
            ];
          }
          self.nixosModules.default
          config.nixos.shared
          ./${hostname}
        ];
      };
  in {
    anchor = mkSystem {
      hostname = "anchor";
      user = "thieu";
    };

    wanderer = mkSystem {
      hostname = "wanderer";
      user = "thieu";
    };
  };
}
