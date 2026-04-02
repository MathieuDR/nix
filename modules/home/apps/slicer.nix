{...}: {
  flake.modules.homeManager.slicer = {pkgs, ...}: {
    home.packages = with pkgs; [
      super-slicer-latest
    ];
  };
}
