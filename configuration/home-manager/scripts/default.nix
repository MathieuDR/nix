{
  pkgs,
  config,
  self,
  ...
}: {
  home.packages = [
    # (import ./rofi-systemd.nix {inherit pkgs;})
    (import ./list_files_and_contents.nix {inherit pkgs;})
    (import ./diff.nix {inherit pkgs;})
  ];

  imports = [
    ./shlink.nix
  ];
}
