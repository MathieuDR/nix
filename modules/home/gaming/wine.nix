{...}: {
  flake.modules.homeManager.wine = {pkgs, ...}: {
    home.packages = with pkgs; [
      bottles
      winetricks
    ];
  };
}
