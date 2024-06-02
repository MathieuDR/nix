{
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      mangohud
      protonup
    ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
