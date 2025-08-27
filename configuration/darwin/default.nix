{...}: {
  _file = ./default.nix;
  imports = [
    ./aerospace.nix
    ./karabiner.nix
  ];

  # Necessary for using flakes on this system
  nix.settings.experimental-features = "nix-command flakes";

  homebrew = {
    enable = true;

    brews = [
    ];

    casks = [
      "1password-cli"
      "docker"
      "spotify"
      "setapp"
      "obsidian"
      "tuta-mail"
      "ungoogled-chromium"
      "keepassxc"
      "libreoffice"
      "keymapp"
      "raycast"
      "claude"
      "notion"
      "signal"
      "obs"
    ];
  };
}
