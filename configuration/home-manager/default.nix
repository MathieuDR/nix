{
  self,
  pkgs,
  inputs,
  hostname,
  isDarwin,
  lib,
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

  fonts.fontconfig.enable = !isDarwin;
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs;
      [
        # Cross-platform packages
        # dev
        vscode

        # nixvim package
        (inputs.yvim.packages.x86_64-linux.default)

        # cli tools
        csvkit
        bat
        bottom
        du-dust
        mosh
        fd
        fx
        procs
        yq
        tree
        just
        zip
        unzip
        gotop
        img2pdf
        imagemagick
        dnsutils
        nmap
        rsync
        rclone
        file

        # productive programs
        zathura

        # social programs
        slack
        discord
        element-desktop

        # common programs
        floorp
        firefox
        keepassxc
        gzip

        # custom packages
        self.packages.${pkgs.system}.highlight-exporter
        self.packages.${pkgs.system}.zeit
      ]
      ++ lib.optionals (!isDarwin) [
        # Linux-only packages

        # fonts
        nerd-fonts.jetbrains-mono
        noto-fonts-emoji
        roboto
        ubuntu_font_family
        ubuntu-sans
        ubuntu-classic

        # cli tools
        killall
        imv

        # productive programs
        obsidian
        libreoffice
        pkgs.kdePackages.okular
        simple-scan

        # social programs
        betterdiscordctl
        tutanota-desktop

        # common programs
        ungoogled-chromium
        filezilla
        file-roller
        kooha

        # system utilities
        blueman
        pavucontrol
      ]
      ++ lib.optionals isDarwin [
        # macOS-only packages
      ];
  };

  xdg.configFile."${hostname}" = {
    source = "${self}/data/config/";
    recursive = true;
  };
}
