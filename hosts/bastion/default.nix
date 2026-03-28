{inputs, ...}: let
  nixosCfg = inputs.self.nixosConfigurations.bastion.config;
in {
  flake.nixosConfigurations.bastion = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [
      base
      networking
      user
      security
      sound
      hyprland
      espanso
      services
      cleanup
      maintenance
      packages
      unfree
      gaming
      hardware-amd
      hardware-wine
      podman

      ./hardware-configuration.nix
      inputs.agenix.nixosModules.default

      {
        networking.hostName = "bastion";
        nixpkgs.overlays = [
          inputs.self.overlays.default
          inputs.nur.overlays.default
        ];
      }
    ];
  };

  flake.homeConfigurations."thieu@bastion" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [
        inputs.self.overlays.default
        inputs.nur.overlays.default
      ];
    };
    extraSpecialArgs = {
      inherit inputs;
      osConfig = nixosCfg;
    };
    modules =
      (with inputs.self.modules.homeManager; [
        base
        nvim
        shell
        fish
        filemanager
        navi
        catppuccin
        hwdr
        kitty
        espanso
        copyq
        zen
        imv
        mpv
        gaming
        syncthing
        transcriber
        discord-fix
        signal
        wine
        ccalibration
        stresstests
        healthchecks
        # hyprlock
        slicer
      ])
      ++ [
        ./monitors.nix
        ./startup.nix
        ./misc.nix

        inputs.agenix.homeManagerModules.default
        inputs.catppuccin.homeModules.catppuccin
        inputs.spicetify-nix.homeManagerModules.default
      ];
  };
}
