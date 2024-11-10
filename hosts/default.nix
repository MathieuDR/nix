{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;

    # homeImports = import "${self}/home/profiles";
    # mod = "${self}/configuration";

    # get these into the module system
    # specialArgs = {inherit inputs self;};

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
