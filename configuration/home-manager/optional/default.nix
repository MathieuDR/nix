{
  gaming = import ./gaming.nix;

  theming = {
    general = import ./theming/general.nix;
    spotify = import ./theming/spotify.nix;
  };

  fixes = {
    discord = import ./fixes/discord.nix;
  };

  programs = {
    _3d = import ./programs/3d.nix;
    copyq = import ./programs/copyq.nix;
    dev = import ./programs/dev.nix;
    zen = import ./programs/zen.nix;
    mpv = import ./programs/mpv.nix;
    signal = import ./programs/signal.nix;
    wayland-espanso = import ./programs/wayland-espanso.nix;
  };
}
