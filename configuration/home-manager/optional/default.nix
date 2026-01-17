{
  gaming = import ./gaming.nix;
  stresstests = import ./stresstests.nix;

  bootstrapped = import ./bootstrapped;

  hardware = {
    nvidia = import ./hardware/nvidia.nix;
  };

  theming = {
    general = import ./theming/general.nix;
    linux = import ./theming/linux.nix;
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
    imv = import ./programs/imv.nix;
    signal = import ./programs/signal.nix;
    wayland-espanso = import ./programs/wayland-espanso.nix;
    wine = import ./programs/wine.nix;
  };
}
