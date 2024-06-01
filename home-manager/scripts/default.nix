{pkgs, ...}: {
  home.packages = [
    (import ./powermenu.nix {inherit pkgs;})
  ];
}
