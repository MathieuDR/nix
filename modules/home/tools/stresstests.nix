{...}: {
  flake.modules.homeManager.stresstests = {pkgs, ...}: {
    home.packages = with pkgs; [
      furmark
      stress-ng
    ];
  };
}
