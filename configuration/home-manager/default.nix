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
    ./signal.nix
    ./espanso.nix
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

      #Productive programs
      obsidian
      libreoffice
      pkgs.kdePackages.okular
      zathura

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

      #Necessary
      blueman
      pavucontrol

      #Custom
      self.packages.${pkgs.system}.highlight-exporter
      self.packages.${pkgs.system}.zeit
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/matrix" = ["${pkgs.element-desktop.pname}.desktop"];
      "x-scheme-handler/io.element.desktop" = ["${pkgs.element-desktop.pname}.desktop"];
      "x-scheme-handler/elements" = ["${pkgs.element-desktop.pname}.desktop"];
    };
  };

  xdg.configFile."${hostname}" = {
    source = "${self}/data/config/";
    recursive = true;
  };
}
