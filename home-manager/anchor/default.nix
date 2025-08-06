{
  self,
  pkgs,
  ...
}: let
  optional = (import "${self}/configuration").home-manager.optional;
in {
  imports = [
    ./desktop-environment.nix

    optional.gaming
    optional.theming.general
    optional.theming.spotify
    optional.fixes.discord
    optional.programs.copyq
    optional.programs.signal
    optional.programs.zen
    optional.programs.mpv
    optional.programs.dev
    optional.programs._3d
  ];

  home = {
    username = "thieu";
    homeDirectory = "/home/thieu";
    stateVersion = "23.11"; # Please read the comment before changing.

    packages = with pkgs; [
      calibre
    ];
  };

  ysomic.hardware.nvidia.enable = true;
  ysomic.applications.rofi.enable = true;
}
