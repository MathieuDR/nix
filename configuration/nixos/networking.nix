{
  self,
  config,
  hostname,
  ...
}: let
  env_file = "${hostname}/networking.conf";
in {
  age.secrets = {
    networks = {
      file = "${self}/data/secrets/system/networking.age";
      path = "/etc/${env_file}";
      mode = "0640";
    };
  };

  networking = {
    hostName = hostname;

    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    #TODO: We can use either wireless or networkmanager.
    wireless = {
      enable = false;
      networks.BeeConnected.pskRaw = "ext:psk_home";
      secretsFile = config.age.secrets.networks.path;
    };
  };
}
