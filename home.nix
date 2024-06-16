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
      wl-clipboard

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

      #Necessary
      blueman
      pavucontrol
    ];

    activation = {
      dirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run mkdir -p "./development/sources"
        run mkdir -p "./development/sources/sevenmind"
        run mkdir -p "./notes"
        run mkdir -p "./pictures/screenshots"
        run mkdir -p "./secrets/keepass"
      '';

      # discord = lib.hm.dag.entryAfter ["writeBoundary"] ''
      #   betterdiscordctl install
      # '';
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

  xdg.desktopEntries = {
    #TEMP: discord fix
    discord = {
      exec = "discord --in-progress-gpu --use-gl=desktop";
      name = "Discord";
    };

    whatsapp = {
      name = "WhatsApp";
      exec = "open_kiosk_in_window_and_workspace floorp \"https://web.whatsapp.com\" floorp 1";
      type = "Application";
    };
  };

  programs.home-manager.enable = true;
}
