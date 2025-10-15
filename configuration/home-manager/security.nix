{
  self,
  pkgs,
  config,
  isDarwin,
  ...
}: let
  secretsDir = "${self}/data/secrets";
  commonPub = "${secretsDir}/public_keys/gpg.pub";
in {
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = commonPub;
        trust = "ultimate";
      }
    ];
  };
  age = {
    identityPaths = ["${config.home.homeDirectory}/.config/agenix/agenix-key"];
    secrets = {
      "user/gpg" = {
        file = "${secretsDir}/user/gpg.age";
        path = "${config.home.homeDirectory}/secrets/gpg/common.gpg";
      };
    };
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
