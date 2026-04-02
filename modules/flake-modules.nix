# Declares flake.modules.{nixos,homeManager} as mergeable options
# so each aspect file can contribute individual module definitions.
{lib, ...}: {
  options.flake.modules = {
    nixos = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = {};
      description = "NixOS aspect modules (assembled in hosts.nix)";
    };
    homeManager = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = {};
      description = "Home Manager aspect modules (assembled in hosts.nix)";
    };
  };
}
