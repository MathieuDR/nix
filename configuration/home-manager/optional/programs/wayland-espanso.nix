{
  pkgs,
  nixosConfig,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      _espanso-wayland-orig = prev.espanso-wayland;
      espanso-wayland = pkgs.callPackage ./overrides/espanso.nix {
        capDacOverrideWrapperDir = "${nixosConfig.security.wrapperDir}";
        espanso = prev.espanso-wayland;
      };
    })
  ];

  ysomic.applications.espanse.package = pkgs.espanso-wayland;
}
