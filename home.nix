{
  pkgs,
  lib,
  inputs,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";
    };
  };

  imports = [
    ./home-manager
  ];

  home = {
    username = "Thieu";
    homeDirectory = "/home/Thieu";
    stateVersion = "23.11"; # Please read the comment before changing.

    packages = with pkgs; [
      #Fonts
      (pkgs.nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })

      #Dev env
      vscode
      (inputs.yvim.packages.x86_64-linux.default)

      #cli
      yq
      tree

      #Productive programs
      obsidian

      #Social programs
      slack
      betterdiscordctl
      discord
			whatsapp-for-linux

      #Common programs
      floorp
      firefox
      keepassxc
      spotify
      spicetify-cli
    ];

    activation = {
      dirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run mkdir -p "./development/sources"
        run mkdir -p "./development/sources/sevenmind"
        run mkdir -p "./notes"
        run mkdir -p "./secrets/keepass"
      '';
    };

    # file = {
    #   ".config/.ysomic.omp.json".source = ./home-manager/dotfiles/.ysomic.omp.json;
    # };

    # Home Manager can also manage your environment variables through
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  services = {
    copyq.enable = true;
  };

  #TEMP: discord fix
  xdg.desktopEntries.discord.exec = "discord --in-progress-gu --use-gl=desktop";
  xdg.desktopEntries.discord.name = "Discord";

  programs.home-manager.enable = true;
}
