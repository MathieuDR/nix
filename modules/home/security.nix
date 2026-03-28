{inputs, ...}: let
  secretsDir = "${inputs.self}/data/secrets";
in {
  flake.modules.homeManager.security = {
    pkgs,
    config,
    ...
  }: {
    programs.gpg = {
      enable = true;
      publicKeys = [
        {
          source = "${secretsDir}/public_keys/gpg.pub";
          trust = "ultimate";
        }
      ];
    };

    age = {
      identityPaths = ["${config.home.homeDirectory}/.config/agenix/agenix-key"];
      secrets."user/gpg" = {
        file = "${secretsDir}/user/gpg.age";
        path = "${config.home.homeDirectory}/secrets/gpg/common.gpg";
      };
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 7200; # 2 hours
      maxCacheTtl = 28800; # 8 hours
      enableBashIntegration = true;
      pinentry.package = pkgs.pinentry-gnome3;
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
    };
  };
}
