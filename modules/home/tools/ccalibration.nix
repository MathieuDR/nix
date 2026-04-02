{...}: {
  flake.modules.homeManager.ccalibration = {pkgs, ...}: {
    home.packages = with pkgs; [
      argyllcms
      displaycal
    ];
  };
}
