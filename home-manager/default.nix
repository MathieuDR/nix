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
      system ? "x86_64-linux",
      isDarwin ? false,
      alias ? null,
    }: let
      configName =
        if alias != null
        then alias
        else hostname;
    in
      homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            self.overlays.default
            inputs.nur.overlays.default
          ];
        };

        extraSpecialArgs =
          {
            inherit inputs self user hostname isDarwin;
            nixpkgs = inputs.nixpkgs;
            alias = configName;
          }
          // (
            if isDarwin
            then {
              # For Darwin, reference the Darwin configuration instead of NixOS
              darwinConfig = self.darwinConfigurations.${hostname}.config;
            }
            else {
              # For NixOS, keep the existing reference
              nixosConfig = self.nixosConfigurations.${hostname}.config;
            }
          );

        modules = [
          self.homeManagerModules.default
          inputs.agenix.homeManagerModules.default
          inputs.catppuccin.homeModules.catppuccin
          config.home-manager.shared
          ./${configName}
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

    "thieu@7mind-JJ9C5X225D" = mkHome {
      hostname = "7mind-JJ9C5X225D";
      user = "thieu";
      system = "aarch64-darwin";
      isDarwin = true;
      alias = "imposter";
    };
  };
}
