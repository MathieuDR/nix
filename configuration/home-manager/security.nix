{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  secretsDir = "${self}/data/secrets";
  commonPub = "${secretsDir}/public_keys/gpg.pub";
  gpgKeys = ["user/gpg"];

  # We create a trigger file on activation to make sure we only run once per activation
  versionFile = "${config.home.homeDirectory}/.local/state/gpg-import-version";

  # We create a version using a manual version and a hash
  # The manual version forces to reimport on key changes with the same name
  # Note, private keys will still not be imported, that's how GPG import works.
  manualVersion = "1";
  gpgKeysHash = builtins.hashString "sha256" (builtins.toString gpgKeys);
  combinedVersion = "${manualVersion}-${gpgKeysHash}";

  # Cleanup script, that will be ran in a separate systemd service
  # The reason it's in a separate one is, that we guarantee the run onSuccess or OnFailure.
  # If we don't do this, we need to jump around hoops and trap exits to make sure we remove the link / shred of the decrypted keys
  cleanupScriptFunc = keys:
    lib.concatMapStrings (key: ''
      keyPath="${config.age.secrets."${key}".path}"
      if [ -L "$keyPath" ]; then
        echo "Will unlink symlink of GPG Key: $keyPath"
        ${pkgs.coreutils}/bin/unlink "$keyPath"
      elif [ -f "$keyPath" ]; then
        echo "Will shred GPG Key: $keyPath"
        ${pkgs.coreutils}/bin/shred -u "$keyPath"
      else
        echo "Key not found: $keyPath"
      fi
    '')
    keys;

  cleanupScript = pkgs.writeShellScriptBin "cleanup-gpg-keys" ''
    ${cleanupScriptFunc gpgKeys}
  '';

  # Trigger keys, a list of strings.
  # Uses systemd condition path exists with an 'or' prefix.
  # More info: https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html#Conditions%20and%20Asserts
  triggerPaths = keys:
    map (key: "|${config.age.secrets.${key}.path}") keys;

  # Main script + import script
  mkGpgImportsWithFunc = keys:
    lib.concatMapStrings (key: ''
      echo "Attempting to import key: ${key}"
      import_gpg_key "${config.age.secrets.${key}.path}"
    '')
    keys;

  importScript = pkgs.writeShellScriptBin "import-gpg-keys" ''
    # First check version
    if [ -f "${versionFile}" ]; then
      current_version=$(cat "${versionFile}")
      if [ "$current_version" = "${combinedVersion}" ]; then
        echo "GPG keys already imported at version ${manualVersion} with current keys"
        exit 0
      else
        echo "Version mismatch:"
        echo "Current: $current_version"
        echo "New: ${combinedVersion}"
      fi
    else
      echo "No version file found, will import keys"
    fi

    # Import function
    import_gpg_key() {
      local key_path="$1"
      if [ -f "$key_path" ]; then
        echo "Will import key: $key_path"
        local gpg_output
        gpg_output=$(${pkgs.gnupg}/bin/gpg --import "$key_path" 2>&1)
        local gpg_exit_code=$?

        if echo "$gpg_output" | grep -q "not changed"; then
          echo "Warning: Key $key_name already exists and wasn't modified"
        elif echo "$gpg_output" | grep -q "secret key already exists"; then
          echo "Warning: Secret key $key_name already exists"
        fi

        if [ $gpg_exit_code -ne 0 ]; then
          echo "Error: Failed to import GPG key: $key_path"
          echo "GPG output: $gpg_output"
          return 1
        else
          echo "GPG imported: $key_path"
        fi

      else
        echo "Path not found: $key_path"
        return 1
      fi
    }

    # Import statements for each key
    ${mkGpgImportsWithFunc gpgKeys}

    # Create new version
    mkdir -p "$(dirname "${versionFile}")"
    echo "${combinedVersion}" > "${versionFile}"
    echo "Updated version to ${combinedVersion}"
  '';

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

  services.gpg-agent = let
    pinentryRouter = pkgs.writeShellScriptBin "pinentry-router" ''
      # Helper function to find a usable TTY
      find_tty() {
        # Try different methods to find TTY
        if [ -n "$SSH_TTY" ]; then
          echo "$SSH_TTY"
        elif [ -n "$GPG_TTY" ]; then
          echo "$GPG_TTY"
        elif tty 2>/dev/null; then
          tty
        else
          echo ""
        fi
      }

      # Get TTY before we do anything else
      USABLE_TTY=$(find_tty)

      # Enhanced debugging
      {
        echo "=== New pinentry request ==="
        echo "Date: $(date)"
        echo "TERM: $TERM"
        echo "NVIM: $NVIM"
        echo "GPG_TTY: $GPG_TTY"
        echo "SSH_TTY: $SSH_TTY"
        echo "Found TTY: $USABLE_TTY"
        echo "Parent Process: $(ps -o cmd= -p $PPID)"
        echo "Current Process: $$"
      } >> /tmp/pinentry-debug.log

      if [ -n "$USABLE_TTY" ]; then
        export GPG_TTY="$USABLE_TTY"
      fi

      # Enhanced detection logic
      if [ -n "$NVIM" ] || ps -o cmd= -p $PPID | grep -q "nvim"; then
        echo "Using gnome3 for Neovim session" >> /tmp/pinentry-debug.log
        exec ${pkgs.pinentry-gnome3}/bin/pinentry-gnome3 "$@"
      elif [ -z "$USABLE_TTY" ]; then
        echo "No TTY available, forcing gnome3" >> /tmp/pinentry-debug.log
        exec ${pkgs.pinentry-gnome3}/bin/pinentry-gnome3 "$@"
      elif [ "$TERM" = "xterm-kitty" ]; then
        echo "Using curses for Kitty terminal" >> /tmp/pinentry-debug.log
        exec ${pkgs.pinentry-curses}/bin/pinentry-curses "$@"
      else
        echo "Default case: Using gnome3" >> /tmp/pinentry-debug.log
        exec ${pkgs.pinentry-gnome3}/bin/pinentry-gnome3 "$@"
      fi
    '';
  in {
    enable = true;
    enableBashIntegration = true;
    pinentryPackage = pkgs.pinentry-gnome3;

    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
      pinentry-program ${pinentryRouter}/bin/pinentry-router
    '';
  };

  # Systemd services
  systemd.user.services = {
    # Main import service
    import-gpg-keys = {
      Unit = {
        Description = "Import GPG keys (v${manualVersion})";
        After = ["agenix.service"];
        ConditionPathExists = triggerPaths gpgKeys;
      };

      Install = {
        WantedBy = ["default.target"];
      };

      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${importScript}/bin/import-gpg-keys";
        ExecStopPost = "${cleanupScript}/bin/cleanup-gpg-keys";

        # # Isolate the service's /tmp directory
        # PrivateTmp = true;
        # # Prevent privilege escalation
        # NoNewPrivileges = true;
        # # Make the root filesystem read-only except /var, /run, etc
        # ProtectSystem = "strict";
        # # Allow writing to home for the version file
        # # ProtectHome = "read-write";
        # # Restrict network access since we don't need it
        # RestrictAddressFamilies = "AF_UNIX";
        # # Prevent memory exploits
        # MemoryDenyWriteExecute = true;
      };
    };
  };
}
