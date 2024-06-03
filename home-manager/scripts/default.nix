{pkgs, ...}: {
  home.packages = [
    (import ./powermenu.nix {inherit pkgs;})
    (import ./open_app_on_workspace.nix {inherit pkgs;})
  ];
}
