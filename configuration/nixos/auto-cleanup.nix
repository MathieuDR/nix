{...}: {
  nix = {
    #TODO: Check what this is
    settings = {
      auto-optimise-store = true;
    };

    #TODO: Check if it's good
    gc = {
      persistent = true;
      dates = "Thu *-*-* 11:00:00";
      randomizedDelaySec = "30m";
      automatic = true;
      # options = "--delete-older-than 14d --keep-generations 3 --max-freed 20G";
    };
  };
}
