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

  home = {
    stateVersion = "24.11";
  };
}
