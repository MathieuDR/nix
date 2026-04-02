{...}: {
  flake.modules.nixos.cleanup = {
    nix.gc = {
      persistent = true;
      dates = "Thu *-*-* 11:00:00";
      randomizedDelaySec = "30m";
      automatic = true;
    };
  };
}
