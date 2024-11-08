{
  imports = [
    ./theming.nix
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./waybar.nix
    ./rofi.nix
    ./shell.nix
    ./kitty.nix
    ./games.nix
    ./scripts
    ./spicetify.nix
  ];

  # [Default Applications]
  # x-scheme-handler/http=floorp.desktop
  # x-scheme-handler/https=floorp.desktop
  # x-scheme-handler/chrome=floorp.desktop
  # text/html=floorp.desktop
  # application/x-extension-htm=floorp.desktop
  # application/x-extension-html=floorp.desktop
  # application/x-extension-shtml=floorp.desktop
  # application/xhtml+xml=floorp.desktop
  # application/x-extension-xhtml=floorp.desktop
  # application/x-extension-xht=floorp.desktop
  # application/pdf=floorp.desktop
  # x-scheme-handler/discord-409416265891971072=discord-409416265891971072.desktop
  # application/x-compressed-tar=thunar.desktop
  #
  # [Added Associations]
  # x-scheme-handler/http=floorp.desktop;firefox.desktop;
  # x-scheme-handler/https=floorp.desktop;firefox.desktop;
  # x-scheme-handler/chrome=floorp.desktop;firefox.desktop;
  # text/html=floorp.desktop;firefox.desktop;
  # application/x-extension-htm=floorp.desktop;firefox.desktop;
  # application/x-extension-html=floorp.desktop;firefox.desktop;
  # application/x-extension-shtml=floorp.desktop;firefox.desktop;
  # application/xhtml+xml=floorp.desktop;firefox.desktop;
  # application/x-extension-xhtml=floorp.desktop;firefox.desktop;
  # application/x-extension-xht=floorp.desktop;firefox.desktop;
  # text/plain=org.gnome.gedit.desktop;
  # application/pdf=floorp.desktop;
  # application/x-compressed-tar=thunar.desktop;
  # application/vnd.oasis.opendocument.text=writer.desktop;
  # application/vnd.openxmlformats-officedocument.wordprocessingml.document=writer.desktop;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = ["floorp.desktop"];
      "x-scheme-handler/https" = ["floorp.desktop"];
      "x-scheme-handler/chrome" = ["floorp.desktop"];
      "text/html" = ["floorp.desktop"];
      "application/x-extension-htm" = ["floorp.desktop"];
      "application/x-extension-html" = ["floorp.desktop"];
      "application/x-extension-shtml" = ["floorp.desktop"];
      "application/xhtml+xml" = ["floorp.desktop"];
      "application/x-extension-xhtml" = ["floorp.desktop"];
      "application/x-extension-xht" = ["floorp.desktop"];
      "application/pdf" = ["okularApplication_pdf.desktop" "floorp.desktop"];
      "x-scheme-handler/discord-409416265891971072" = ["discord-409416265891971072.desktop"];
      "x-scheme-handler/discord" = ["discord.desktop"];
      "x-scheme-handler/slack" = ["slack.desktop"];
      "application/x-compressed-tar" = ["thunar.desktop"];
    };

    associations.added = {
      "x-scheme-handler/http" = ["floorp.desktop" "firefox.desktop"];
      "x-scheme-handler/https" = ["floorp.desktop" "firefox.desktop"];
      "x-scheme-handler/chrome" = ["floorp.desktop" "firefox.desktop"];
      "text/html" = ["floorp.desktop" "firefox.desktop"];
      "application/x-extension-htm" = ["floorp.desktop" "firefox.desktop"];
      "application/x-extension-html" = ["floorp.desktop" "firefox.desktop"];
      "application/x-extension-shtml" = ["floorp.desktop" "firefox.desktop"];
      "application/xhtml+xml" = ["floorp.desktop" "firefox.desktop"];
      "application/x-extension-xhtml" = ["floorp.desktop" "firefox.desktop"];
      "application/x-extension-xht" = ["floorp.desktop" "firefox.desktop"];
      "text/plain" = ["org.gnome.gedit.desktop"];
      "application/pdf" = ["okularApplication_pdf.desktop" "floorp.desktop"];
      "application/x-compressed-tar" = ["thunar.desktop"];
      "application/vnd.oasis.opendocument.text" = ["writer.desktop"];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["writer.desktop"];
    };
  };
}
