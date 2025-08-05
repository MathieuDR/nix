# Fix for Floorp crashes - disable LTO support
# See: https://github.com/NixOS/nixpkgs/issues/418473
final: prev: {
  floorp-unwrapped =
    (prev.floorp-unwrapped.override {
      privacySupport = true;
      webrtcSupport = true;
      enableOfficialBranding = false;
      geolocationSupport = true;
      # https://github.com/NixOS/nixpkgs/issues/418473
      ltoSupport = false;
    }).overrideAttrs (prev: {
      MOZ_DATA_REPORTING = "";
      MOZ_TELEMETRY_REPORTING = "";
    });
}
