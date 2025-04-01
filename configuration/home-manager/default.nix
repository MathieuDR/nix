{
  self,
  pkgs,
  config,
  inputs,
  hostname,
  ...
}: {
  imports = [
    ./shell.nix
    ./rofi.nix
    ./security.nix
    ./syncthing.nix
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
      nerd-fonts.jetbrains-mono
      noto-fonts-emoji

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

      #Productive programs
      obsidian
      libreoffice
      okular
      zathura

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
  };

  systemd.user.tmpfiles.rules = [
    # d /path/to/directory MODE USER GROUP AGE ARGUMENT
    "d ${config.home.homeDirectory}/downloads 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/development 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/development/sources 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/development/courses 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/development/sources/sevenmind 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/pictures 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/pictures/screenshots 0755 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/notes 0755 ${config.home.username} users - -"
  ];

  xdg.configFile."${hostname}" = {
    source = "${self}/data/config/";
    recursive = true;
  };
}
