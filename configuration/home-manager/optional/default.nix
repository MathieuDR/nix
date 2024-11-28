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
    copyq = import ./programs/copyq.nix;
  };
}
