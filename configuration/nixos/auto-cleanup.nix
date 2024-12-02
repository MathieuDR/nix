{...}: {
  nix = {
    settings = {
      auto-optimise-store = true;
    };

    gc = {
      persistent = true;
      dates = "Thu *-*-* 11:00:00";
      randomizedDelaySec = "30m";
      automatic = true;
      options = "--delete-older-than 14d --keep-generations 3 --max-freed 20G";
    };
  };
}
