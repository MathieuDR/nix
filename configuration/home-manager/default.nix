{
  self,
  pkgs,
  inputs,
  hostname,
  ...
}: {
  imports = [
    ./files.nix
    ./shell.nix
    ./security.nix
    ./syncthing.nix
    ./espanso.nix
    ./scripts
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      # fonts
      nerd-fonts.jetbrains-mono
      noto-fonts-emoji
      roboto
      ubuntu_font_family
      ubuntu-sans
      ubuntu-classic

      #dev
      vscode

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
      rclone
      file

      #Productive programs
      obsidian
      libreoffice
      pkgs.kdePackages.okular
      zathura
      simple-scan

      #Social programs
      slack
      betterdiscordctl
      discord
      # whatsapp-for-linux
      tutanota-desktop
      element-desktop

      #Common programs
      floorp
      ungoogled-chromium
      firefox
      keepassxc
      calibre
      # calibre-web
      gzip
      filezilla
      file-roller
      kooha

      #Necessary
      blueman
      pavucontrol

      #Custom
      self.packages.${pkgs.system}.highlight-exporter
      self.packages.${pkgs.system}.zeit
    ];
  };

  xdg.configFile."${hostname}" = {
    source = "${self}/data/config/";
    recursive = true;
  };
}
