{pkgs, ...}: {
  home.packages = [
    (import ./powermenu.nix {inherit pkgs;})
    (import ./open_app_on_workspace.nix {inherit pkgs;})
    (import ./kiosk_in_window.nix {inherit pkgs;})
  ];
}
