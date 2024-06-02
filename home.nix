{ config, pkgs, lib, inputs, ... }:

{
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
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

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

    file = {
			".config/.ysomic.omp.json" = "./home-manager/dotfiles/.ysomic.omp.json";
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. If you don't want to manage your shell through Home
    # Manager then you have to manually source 'hm-session-vars.sh' located at
    # either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/Thieu/etc/profile.d/hm-session-vars.sh
    #
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
