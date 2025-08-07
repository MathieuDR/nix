{
  self,
  user,
  config,
  pkgs,
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

  imports = [
    optional.programs.zen
    optional.programs.dev
  ];

  ysomic = {
    applications.defaults = {
      enable = true;
      browser = config.programs.zen-browser.finalPackage;
      pdfReader = pkgs.zathura;
      terminal = "kitty";
      fileManager = "thunar";
    };
  };

  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    stateVersion = "25.05";
  };
}
