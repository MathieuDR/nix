{pkgs, ...}: {
  home.packages = [
    (import ./powermenu.nix {inherit pkgs;})
    (import ./open_app_on_workspace.nix {inherit pkgs;})
    (import ./list_files_and_contents.nix {inherit pkgs;})
    (import ./kiosk_in_window.nix {inherit pkgs;})
    (import ./diff.nix {inherit pkgs;})
  ];
}
