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
      httpie-desktop
      postman

      #cli
      csvkit
      bat
      bottom
      du-dust
      mosh
      fd
      fx
      killall
      procs
      ripgrep
      yq
      tree
      just
      httpie
      wl-clipboard
      zip
      unzip
      gotop
      imv
      img2pdf
      imagemagick
      dnsutils
      nmap
      rsync

      #Productive programs
      obsidian
      libreoffice
      okular

      #Social programs
      slack
      betterdiscordctl
      discord
      whatsapp-for-linux
      tutanota-desktop

      #Common programs
      floorp
      firefox
      keepassxc
      calibre
      calibre-web
      gzip
      filezilla
      file-roller

      #Necessary
      blueman
      pavucontrol

      #Games
      (prismlauncher.override {jdks = [jdk8];})
    ];

    activation = {
      dirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run mkdir -p "./development/sources"
        run mkdir -p "./development/sources/sevenmind"
        run mkdir -p "./notes"
        run mkdir -p "./pictures/screenshots"
        run mkdir -p "./secrets/keepass"
      '';
    };

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
  };

  programs.home-manager.enable = true;
}
