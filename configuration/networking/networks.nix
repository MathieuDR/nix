{...}: {
  networking = {
    wireless = {
      networks.BeeConnected.pskRaw = "ext:psk_home";
      #TODO: Add secrets file through configuration with age
      secretsFile = "/etc/secrets/wifi-secrets.conf";
    };
  };
}
