{
  config,
  pkgs,
  ...
}: let
  # accent = "Mauve";
  accent = "mauve";
  flavor = "mocha";
  # variant = "Mocha";
  cursorSize = 24;
  cursorPackage = pkgs.catppuccin-cursors.mochaMauve;
  cursorName = "catppuccin-mocha-mauve-cursors";
  # kvantumThemePackage = pkgs.catppuccin-kvantum.override {
  #   inherit variant accent;
  # };
in {
  catppuccin = {
    enable = true;
    accent = accent;
    flavor = flavor;
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
    style = {
      name = "kvantum";
      catppuccin = {
        enable = true;
        flavor = flavor;
        accent = accent;
        apply = true;
      };
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

    catppuccin = {
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

  programs = {
    waybar.catppuccin = {
      enable = true;
      flavor = flavor;
    };

    rofi.catppuccin = {
      enable = true;
      flavor = flavor;
    };

    kitty.catppuccin = {
      enable = true;
      flavor = flavor;
    };

    k9s.catppuccin = {
      enable = true;
      flavor = flavor;
    };

    fzf.catppuccin = {
      enable = true;
      flavor = flavor;
    };
  };

  services = {
    dunst.catppuccin = {
      enable = true;
      flavor = flavor;
    };
  };
}
