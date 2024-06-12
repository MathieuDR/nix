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

    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = let
        size = "standard";
        tweaks = ["rimless" "normal"];
      in
        pkgs.catppuccin-gtk.override {
          inherit size tweaks;
          accents = [accent];
          variant = flavor;
        };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {inherit accent flavor;};
    };
  };

  xdg.configFile = let
    gtk4Dir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0";
  in {
    "gtk-4.0/assets".source = "${gtk4Dir}/assets";
    "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
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

  wayland.windowManager.hyprland.catppuccin = {
    enable = true;
    accent = accent;
    flavor = flavor;
  };
}
