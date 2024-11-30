{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  secretsDir = "${self}/data/secrets";
  commonPub = "${secretsDir}/common/pub.gpg";

  mkGpgImportsWithFunc = keys: let
    importStatements =
      lib.concatMapStrings (key: ''
        echo "Attempting to import key: ${key}"
        import_gpg_key "${config.age.secrets.${key}.path}"
      '')
      keys;
  in ''
    import_gpg_key() {
      local key_path="$1"
      if [ -f "$key_path" ]; then
        local gpg_output
        gpg_output=$(run ${pkgs.gnupg}/bin/gpg --import "$key_path" 2>&1)
        local gpg_exit_code=$?

        if echo "$gpg_output" | grep -q "not changed"; then
          echo "Warning: Key $key_name already exists and wasn't modified"
        elif echo "$gpg_output" | grep -q "secret key already exists"; then
          echo "Warning: Secret key $key_name already exists"
        fi

        if [ $gpg_exit_code -ne 0 ]; then
          echo "Error: Failed to import GPG key: $key_path"
          echo "GPG output: $gpg_output"
          failed=1
        else
          echo "GPG imported: $key_path"
        fi

        echo "Will shred GPG Key: $key_path"
        run ${pkgs.coreutils}/bin/shred -u "$key_path"
        [ "$failed" = "1" ] && return 1
      else
        echo "Path not found: $key_path"
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
      file = "${secretsDir}/common/gpg.age";
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
    importPrivateGpgKeys =
      lib.hm.dag.entryAfter ["writeBoundary"]
      (mkGpgImportsWithFunc gpgKeys);
  };
}
