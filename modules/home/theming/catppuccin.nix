{inputs, ...}: {
  flake.modules.homeManager.catppuccin = {pkgs, ...}: let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    cursorSize = 24;
    cursorPackage = pkgs.catppuccin-cursors.mochaMauve;
    cursorName = "catppuccin-mocha-mauve-cursors";
  in {
    catppuccin = {
      enable = true;
      accent = "mauve";
      flavor = "mocha";
    };

    home.pointerCursor = {
      package = cursorPackage;
      name = cursorName;
      size = cursorSize;
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = cursorName;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    gtk = {
      enable = true;
      font.name = "JetBrainsMono Nerd Font";
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };

    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledExtensions = with spicePkgs.extensions; [
        history
        fullAppDisplay
        shuffle
        hidePodcasts
      ];
    };
  };
}
