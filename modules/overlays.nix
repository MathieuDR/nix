{
  self,
  inputs,
  ...
}: {
  flake.overlays.default = inputs.nixpkgs.lib.composeManyExtensions [
    (import ../overlays/stoat.nix {inherit inputs;})
    inputs.claude-desktop.overlays.default
  ];

  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [self.overlays.default];
      config.allowUnfree = true;
    };
  };
}
