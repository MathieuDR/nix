{
  pkgs,
  lib,
  ...
}: {
  nixpkgs = {
    config = {
      permittedInsecurePackages = lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";
    };
  };

  xdg.desktopEntries = {
    #TEMP: discord fix
    discord = {
      exec = "discord --in-progress-gpu --use-gl=desktop";
      name = "Discord";
    };
  };
}
