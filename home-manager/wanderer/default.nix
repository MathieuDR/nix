{self, ...}: let
  optional = (import "${self}/configuration").home-manager.optional;
in {
  imports = [
    ./desktop-environment.nix
    ./monitors.nix

    optional.theming.general
    optional.theming.spotify
    # optional.fixes.discord
    optional.programs.copyq
    optional.programs.dev
  ];

  ysomic.applications.rofi.enable = true;

  home = {
    username = "thieu";
    homeDirectory = "/home/thieu";
    stateVersion = "24.11";
  };
}
