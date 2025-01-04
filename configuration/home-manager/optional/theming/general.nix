{
  config,
  pkgs,
  ...
}: let
  accent = "mauve";
  flavor = "mocha";
  cursorSize = 24;
  cursorPackage = pkgs.catppuccin-cursors.mochaMauve;
  cursorName = "catppuccin-mocha-mauve-cursors";
in {
  catppuccin = {
    enable = true;
    accent = accent;
    flavor = flavor;

    waybar = {
      enable = true;
      flavor = flavor;
    };

    rofi = {
      enable = true;
      flavor = flavor;
    };

    kitty = {
      enable = true;
      flavor = flavor;
    };

    k9s = {
      enable = true;
      flavor = flavor;
    };

    fzf = {
      enable = true;
      flavor = flavor;
    };

    kvantum = {
      apply = true;
      accent = accent;
      flavor = flavor;
      enable = true;
    };

    # Deprecated soon
    gtk = {
      enable = true;
      accent = accent;
      flavor = flavor;
      icon = {
        enable = true;
        accent = accent;
        flavor = flavor;
      };
      size = "standard";
      tweaks = ["rimless" "normal"];
    };

    dunst = {
      enable = true;
      flavor = flavor;
    };
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

  # Do we still need this?
  xdg.configFile = let
    gtk4Dir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0";
  in {
    "gtk-4.0/assets".source = "${gtk4Dir}/assets";
    "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
  };

  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
    };

    # cursorTheme = {
    #   package = cursorPackage;
    #   size = cursorSize;
    #   name = cursorName;
    # };

    # theme = {
    #   name = "Catppuccin-Mocha-Standard-Mauve-Dark";
    #   package = let
    #     size = "standard";
    #     tweaks = ["rimless" "normal"];
    #   in
    #     pkgs.catppuccin-gtk.override {
    #       inherit size tweaks;
    #       accents = [accent];
    #       variant = flavor;
    #     };
    # };
    #
    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.catppuccin-papirus-folders.override {inherit accent flavor;};
    # };
  };
}
