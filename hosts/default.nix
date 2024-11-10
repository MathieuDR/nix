{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mkSystem = {
      hostname,
      user,
    }:
      nixosSystem {
        specialArgs = {
          inherit inputs self hostname user;
        };
        modules = [
          self.nixosModules.default
          "${self}/configuration"
          ./${hostname}
        ];
      };
  in {
    anchor = mkSystem {
      hostname = "anchor";
      user = "thieu";
    };
    # wanderer = mkSystem "wanderer";
  };
}
