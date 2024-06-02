{
  pkgs,
  lib,
  ...
}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  home = {
    packages = with pkgs; [
      mangohud
      protonup
    ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };

    activation = {
      steam = lib.hm.dag.entryAfter ["writeBoundary"] ''
        protonup
      '';
    };
  };
}
