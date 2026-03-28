{...}: {
  flake.modules.homeManager.gaming = {
    pkgs,
    lib,
    osConfig,
    ...
  }:
    lib.mkIf osConfig.programs.steam.enable {
      home = {
        packages = with pkgs; [
          mangohud
          protonup-ng
          runelite
        ];

        sessionVariables = {
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
        };
      };
    };
}
