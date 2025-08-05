{self, ...}: let
  optional = (import "${self}/configuration").home-manager.optional;
in {
  imports = [
    optional.theming.general
    # optional.theming.spotify
    optional.programs.copyq
    optional.programs.dev
  ];
}
