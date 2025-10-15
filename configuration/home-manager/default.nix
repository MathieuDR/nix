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
    ./navi.nix
    ./shell.nix
    ./security.nix
    ./scripts
  ];

  ysomic.applications.espanso.enable = true;

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs;
      [
        # Cross-platform packages
        # fonts
        nerd-fonts.jetbrains-mono
        noto-fonts-emoji
        roboto
        ubuntu_font_family
        ubuntu-sans
        ubuntu-classic

        # dev
        (inputs.yvim.packages.${pkgs.system}.default)
        vscode

        # cli tools - text processing
        sd # modern sed replacement for text substitution
        bat # cat with syntax highlighting and git integration
        jq # json processor
        jnv # interactive JSON viewer and processor
        yq # YAML/JSON/XML processor
        csvkit # suite of CSV manipulation tools
        file # determine file type

        # cli tools - file operations
        eza # modern ls replacement
        fd # modern find replacement
        tree # display directory structure
        rsync # file synchronization
        rclone # cloud storage sync
        zip
        unzip

        # cli tools - system monitoring
        bottom # modern top/htop replacement
        du-dust # modern du replacement showing disk usage
        gotop # terminal-based graphical activity monitor
        procs # modern ps replacement

        # cli tools - network/system
        dnsutils # DNS tools (dig, nslookup, etc)
        nmap # network discovery and security auditing

        # cli tools - build/automation
        just # command runner, modern make alternative

        # cli tools - media
        img2pdf # convert images to PDF
        imagemagick # image manipulation toolkit

        # productive programs
        zathura

        # social programs
        slack
        discord
        element-desktop

        # common programs
        firefox
        gzip

        # custom packages
        self.packages.${pkgs.system}.highlight-exporter
        self.packages.${pkgs.system}.zeit
      ]
      ++ lib.optionals (!isDarwin) [
        # Linux-only packages
        # cli tools
        killall
        imv

        # productive programs
        obsidian
        libreoffice
        pkgs.kdePackages.okular
        simple-scan
        easyeffects

        # social programs
        betterdiscordctl
        tutanota-desktop

        # common programs
        ungoogled-chromium
        filezilla
        file-roller
        kooha
        keepassxc
        floorp-bin
        popsicle

        # system utilities
        blueman
        pavucontrol
        lm_sensors
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
