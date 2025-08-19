{
  self,
  config,
  lib,
  pkgs,
  isDarwin,
  ...
}: let
  secretsDir = "${self}/data/secrets";
  commonPub = "${secretsDir}/public_keys/gpg.pub";
  gpgKeys = ["user/gpg"];

  assertions = [
    {
      assertion = lib.all (key: lib.hasAttr key config.age.secrets) gpgKeys;
      message = let
        # Find which keys are missing
        missingKeys = lib.filter (key: !(lib.hasAttr key config.age.secrets)) gpgKeys;
      in "The following GPG keys are in gpgKeys but not in age.secrets: ${toString missingKeys}";
    }
  ];
in {
  inherit assertions;

  age = {
    identityPaths = ["${config.home.homeDirectory}/.config/agenix/agenix-key"];
    secrets = {
      "user/gpg" = {
        file = "${secretsDir}/user/gpg.age";
        path = "${config.home.homeDirectory}/secrets/gpg/common.gpg.temp";
      };
    };
  };

  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = commonPub;
        trust = "ultimate";
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    # 2 hours
    defaultCacheTtl = 7200;
    # 8 hours
    maxCacheTtl = 28800;
    enableBashIntegration = true;
    pinentry.package =
      if isDarwin
      then pkgs.pinentry_mac
      else pkgs.pinentry-gnome3;

    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };
}
