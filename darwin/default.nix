{
  self,
  inputs,
  ...
}: {
  flake.darwinConfigurations = let
    inherit (inputs.nix-darwin.lib) darwinSystem;
    config = import "${self}/configuration";

    mkDarwin = {
      hostname,
      user,
      system ? "aarch64-darwin",
      alias ? null,
    }: let
      configName =
        if alias != null
        then alias
        else hostname;
    in
      darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs self hostname user;
          alias = configName;
        };
        modules = [
          {
            nixpkgs.overlays = [
              self.overlays.default
              inputs.nur.overlays.default
            ];
          }

          config.darwin.shared
          ./${configName}

          {
            # Basic Darwin configuration
            # Set Git commit hash for darwin-version
            system.configurationRevision = self.rev or self.dirtyRev or null;

            # Used for backwards compatibility
            system.stateVersion = 6;

            # The platform the configuration will be used on
            nixpkgs.hostPlatform = system;
          }
        ];
      };
  in {
    "7mind-JJ9C5X225D" = mkDarwin {
      hostname = "7mind-JJ9C5X225D";
      user = "thieu";
      system = "aarch64-darwin";
      alias = "imposter";
    };
  };
}
