{inputs, ...}: {
  flake.modules.nixos.networking = {config, ...}: {
    age.secrets.networks = {
      file = "${inputs.self}/data/secrets/system/networking.age";
      path = "/etc/${config.networking.hostName}/networking.conf";
      mode = "0640";
    };

    networking.networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
}
