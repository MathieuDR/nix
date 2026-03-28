{...}: {
  flake.modules.homeManager.filemanager = {pkgs, ...}: {
    home.packages = [pkgs.thunar];
  };
}
