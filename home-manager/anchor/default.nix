{self, ...}: let
  optional = (import "${self}/configuration").home-manager.optional;
in {
  imports = [
    ./desktop-environment.nix

    optional.gaming
    optional.theming.general
    optional.theming.spotify
    optional.fixes.discord
    optional.programs.copyq
  ];

  home = {
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  ysomic.hardware.nvidia.enable = true;
}
