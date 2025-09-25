{
  self,
  inputs,
  ...
}: {
  flake.overlays = {
    # Convenience overlay that combines all overlays
    default = inputs.nixpkgs.lib.composeManyExtensions [
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
