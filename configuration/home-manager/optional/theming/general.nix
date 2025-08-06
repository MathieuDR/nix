{
  config,
  pkgs,
  ...
}: let
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

  # Might be able to remove this.
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    # theme = {
    #   name = "catppucin-mocha-mauve-standard+default";
    #   package = pkgs.catppuccin-gtk.override {
    #     size = "standard";
    #     tweaks = ["rimless" "normal"];
    #     accents = ["mauve"];
    #     variant = "mocha";
    #   };
    # };

    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.catppuccin-papirus-folders.override {
    #     accent = "mauve";
    #     flavor = "mocha";
    #   };
    # };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Ensure GTK4 theming works
  # xdg.configFile = {
  #   "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
  #   "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
  #   "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  # };
}
