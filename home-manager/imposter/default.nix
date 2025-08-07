{
  self,
  user,
  config,
  ...
}: let
  optional = (import "${self}/configuration").home-manager.optional;
in {
  imports = [
    optional.programs.zen
    optional.programs.dev
    optional.theming.general
  ];

  ysomic = {
    applications = {
      browser = {
        enable = true;
        setAsDefault = false;
        package = config.programs.zen-browser.finalPackage;
      };

      terminal.enable = true;
    };
  };

  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    stateVersion = "25.05";
  };
}
