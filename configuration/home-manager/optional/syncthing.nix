{
  config,
  isDarwin,
  lib,
  ...
}: {
  services.syncthing = {
    enable = true;

    settings = {
      folders = {
        "secrets" = {
          enable = true;
          path = "${config.home.homeDirectory}/secrets/shared";
          id = "shared-secrets";
          label = "Shared Secrets";
          type = "sendreceive";
          devices = ["anchor" "mobile" "imposter"];
          versioning = {
            type = "staggered";
            fsPath = "${config.home.homeDirectory}/secrets/backup-versions";
            params = {
              # 12 hours
              cleanInterval = "43200";
              # 3 months
              maxAge = "7776000";
            };
          };
        };
      };

      devices = {
        "anchor" = {
          name = "anchor";
          id = "QUED2XA-4E3KEYW-IXGOYIT-3YBTXEV-5XTH43E-IUNCXP6-7KQBAQ6-IO4R6QH";
        };

        "mobile" = {
          name = "mobile";
          id = "WT572IB-2LCXROQ-RKPC5CC-2GDP2KW-47EDGGP-KWCUJCE-XQBVUCB-3DNHLAS";
        };

        "imposter" = {
          name = "imposter";
          id = "HP4TW4P-PE6PJHT-J53MIOZ-6M4RADW-CXXJDAS-SEXRM3V-PFXOSGI-2GVRDQB";
        };
      };

      options = {
        localAnnounceEnabled = true;
        relaysEnabled = true;
        limitBandwidthInLan = false;
      };
    };
  };

  # Linux: Use systemd tmpfiles
  systemd.user.tmpfiles.rules = lib.mkIf (!isDarwin) [
    # d /path/to/directory MODE USER GROUP AGE ARGUMENT
    # 700: Read/Write/Execute for owner, none for group / others
    "d ${config.home.homeDirectory}/secrets 0700 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/secrets/shared 0700 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/secrets/backup-versions 0700 ${config.home.username} users - -"
  ];

  # macOS: Use home.activation to create directories
  home.activation = lib.mkIf isDarwin {
    createSecretsDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p -m 700 "${config.home.homeDirectory}/secrets"
      $DRY_RUN_CMD mkdir -p -m 700 "${config.home.homeDirectory}/secrets/shared"
      $DRY_RUN_CMD mkdir -p -m 700 "${config.home.homeDirectory}/secrets/backup-versions"
    '';
  };
}
