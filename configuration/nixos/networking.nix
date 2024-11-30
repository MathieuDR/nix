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
      file = "${self}/data/secrets/networks.age";
      path = "/etc/${env_file}";
      mode = "0640";
    };
  };

  networking = {
    hostName = hostname;

    wireless = {
      networks.BeeConnected.pskRaw = "ext:psk_home";
      secretsFile = config.age.secrets.networks.path;
    };
  };
}
