{
  self,
  inputs,
  ...
}: {
  flake.overlays = {
    floorp = import ./floorp.nix;
    # Convenience overlay that combines all overlays
    default = inputs.nixpkgs.lib.composeManyExtensions [
      self.overlays.floorp
      # Add other overlays here
    ];
  };

  perSystem = {system, ...}: {
    # This makes pkgs available with overlays applied in perSystem contexts
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [self.overlays.default];
      config.allowUnfree = true;
    };
  };
}
