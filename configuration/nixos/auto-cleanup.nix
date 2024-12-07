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
      # options = "--delete-older-than 14d --keep-generations 3 --max-freed 20G";
    };

    # Stuff is only deleted when NO rule wants to keep it
    # Boot -> once booted into
    profile-gc = {
      enable = true;
      dryRun = true;
      keepLastActiveSystem = 5;
      keepLastActiveBoot = 3;
      keepLatest = "14 days";
      activeThreshold = "4 days";
      activeMeasurementGranularity = "6 hours";
    };
  };
}
