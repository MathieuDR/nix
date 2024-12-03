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
          inputs.agenix.nixosModules.default
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
