{inputs, ...}: {
  flake.modules.homeManager.packages = {pkgs, ...}: {
    home.packages = with pkgs; [
      # dev
      vscode
      forgejo-cli

      # cli tools - text processing
      sd
      bat
      jq
      jnv
      yq-go
      csvkit
      file

      # cli tools - file operations
      fd
      tree
      rsync
      rclone
      zip
      unzip

      # cli tools - system monitoring
      bottom
      dust
      gotop
      procs

      # cli tools - network/system
      dnsutils
      nmap

      # cli tools - build/automation
      just

      # cli tools - media
      img2pdf
      imagemagick

      # productive programs
      zathura

      # social programs
      slack
      mumble
      discord
      stoat-desktop
      element-desktop

      # common programs
      firefox
      gzip

      # custom packages
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.highlight-exporter
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.fleeter
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.zeit

      # Linux-only
      killall
      obsidian
      libreoffice
      kdePackages.okular
      simple-scan
      easyeffects
      claude-desktop-fhs
      betterdiscordctl
      tutanota-desktop
      ungoogled-chromium
      filezilla
      file-roller
      kooha
      keepassxc
      popsicle
      blueman
      pavucontrol
      lm_sensors
    ];
  };
}
