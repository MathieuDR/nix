{...}: {
  flake.modules.homeManager.syncthing = {config, ...}: {
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
            devices = ["wanderer" "mobile" "imposter" "bastion"];
            versioning = {
              type = "staggered";
              fsPath = "${config.home.homeDirectory}/secrets/backup-versions";
              params = {
                cleanInterval = "43200"; # 12 hours
                maxAge = "7776000"; # 3 months
              };
            };
          };
        };

        devices = {
          # Tower
          "bastion" = {
            name = "bastion";
            id = "POE5SHE-34YJMHG-Q7FATME-7YYUVPH-SL2P4ZZ-45SHHN3-A3XBRWD-6GPTJQZ";
          };

          # Mac
          "imposter" = {
            name = "imposter";
            id = "HP4TW4P-PE6PJHT-J53MIOZ-6M4RADW-CXXJDAS-SEXRM3V-PFXOSGI-2GVRDQB";
          };

          # Pixel 6a
          "mobile" = {
            name = "mobile";
            id = "WT572IB-2LCXROQ-RKPC5CC-2GDP2KW-47EDGGP-KWCUJCE-XQBVUCB-3DNHLAS";
          };

          # Pixel 9
          "wanderer" = {
            name = "wanderer";
            id = "2GPANBZ-QFOVSED-6F5W7M5-FYDAGL3-5YAO5MH-U5YOXTT-YKEBRVO-W2BHJAC";
          };
        };

        options = {
          localAnnounceEnabled = true;
          relaysEnabled = true;
          limitBandwidthInLan = false;
        };
      };
    };

    systemd.user.tmpfiles.rules = [
      "d ${config.home.homeDirectory}/secrets 0700 ${config.home.username} users - -"
      "d ${config.home.homeDirectory}/secrets/shared 0700 ${config.home.username} users - -"
      "d ${config.home.homeDirectory}/secrets/backup-versions 0700 ${config.home.username} users - -"
    ];
  };
}
