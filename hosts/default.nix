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
  in {
    anchor = nixosSystem {
      inherit specialArgs;
      modules = [
        ./anchor
      ];
    };
  };
}
