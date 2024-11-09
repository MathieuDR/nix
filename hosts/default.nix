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
    specialArgs = {inherit inputs self;};

    mkSystem = hostname:
      nixosSystem {
        specialArgs = {
          inherit inputs self hostname;
        };
        modules = [
          "${self}/configuration"
          ./${hostname}
        ];
      };
  in {
    anchor = mkSystem "anchor";
    # wanderer = mkSystem "wanderer";
  };
}
