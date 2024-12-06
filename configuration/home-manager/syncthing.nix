{config}: {
  services.syncthing = {
    enable = true;

    settings = {
      folders = {
        "secrets/shared" = {
          path = "${config.home.homeDirectory}/secrets/shared";
          id = "shared_secrets";
          label = "Shared Secrets";
          type = "sendreceive";
          devices = ["anchor" "wanderer" "mobile"];
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
        # "anchor" = {
        #   name = "anchor";
        #   id = "ID";
        # };
        #
        # "wanderer" = {
        #   name = "wanderer";
        #   id = "ID2";
        # };
        #
        # "mobile" = {
        #   name = "mobile";
        #   id = "ID3";
        # };
      };

      options = {
        localAnnounceEnabled = true;
        relaysEnabled = true;
        limitBandwidthInLan = false;
      };
    };
  };

  systemd.user.tmpfiles.rules = [
    # d /path/to/directory MODE USER GROUP AGE ARGUMENT
    # 700: Read/Write/Execute for owner, none for group / others
    "d ${config.home.homeDirectory}/secrets 0700 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/secrets/shared 0700 ${config.home.username} users - -"
    "d ${config.home.homeDirectory}/secrets/backup-versions 0700 ${config.home.username} users - -"
  ];
}
