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
  };
}
