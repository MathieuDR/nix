{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./shell.nix
    ./rofi.nix
    ./security.nix
    ./scripts
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
  home = {
    username = "thieu";
    homeDirectory = "/home/thieu";

    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      # fonts
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
      noto-fonts-emoji

      #dev
      vscode
      httpie
      httpie-desktop
      postman

      #nixvim package
      (inputs.yvim.packages.x86_64-linux.default)

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
      yq
      tree
      just
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
      sumatra

      #Social programs
      slack
      betterdiscordctl
      discord
      # whatsapp-for-linux
      tutanota-desktop

      #Common programs
      floorp
      firefox
      keepassxc
      calibre
      # calibre-web
      gzip
      filezilla
      file-roller

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
    };
  };
}
