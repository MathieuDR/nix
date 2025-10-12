{
  user,
  self,
  pkgs,
  ...
}: let
  optional = (import "${self}/configuration").home-manager.optional;
in {
  imports = [
    ./desktop-environment.nix

    # optional.gaming
    # optional.theming.general
    # optional.theming.linux
    # optional.theming.spotify
    # optional.fixes.discord
    # optional.programs.copyq
    # optional.programs.signal
    # optional.programs.zen
    # optional.programs.mpv
    # optional.programs.dev
    # optional.programs._3d
    # optional.programs.wayland-espanso
  ];

  home = {
    username = user;
    homeDirectory = "/home/thieu";
    stateVersion = "25.11";

    packages = with pkgs; [
      calibre
    ];
  };

  ysomic.applications.rofi.enable = true;
}
