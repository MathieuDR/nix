{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  secretsDir = "${self}/data/secrets";
  commonPub = "${secretsDir}/common_pub.gpg";

  mkGpgImportsWithFunc = keys: let
    importStatements =
      lib.concatMapStrings (key: ''
        import_gpg_key "${config.age.secrets.${key}.path}"
      '')
      keys;
  in ''
    import_gpg_key() {
      local key_path="$1"
      if [ -f "$key_path" ]; then
        if ! run ${pkgs.gnupg}/bin/gpg --import "$key_path"; then
          echo "Failed to import GPG key: $key_path"
          failed=1
        fi
        run ${pkgs.coreutils}/bin/shred -u "$key_path"
        [ "$failed" = "1" ] && return 1
      fi
    }

    ${importStatements}
  '';

  gpgKeys = [
    "common/gpg"
  ];

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

  age.secrets = {
    "common/gpg" = {
      file = "${secretsDir}/gpg.age";
      path = "${config.home.homeDirectory}/secrets/gpg/common.gpg.temp";
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
    enableBashIntegration = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  home.activation = {
    gpgImportKeys =
      lib.hm.dag.entryAfter ["writeBoundary"]
      (mkGpgImportsWithFunc gpgKeys);
  };
}
