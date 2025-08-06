{
  self,
  user,
  ...
}: let
  optional = (import "${self}/configuration").home-manager.optional;
in {
  # imports = [
  # optional.theming.general
  # optional.theming.spotify
  # optional.programs.copyq
  # optional.programs.dev
  # ];

  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    stateVersion = "25.05";
  };
}
