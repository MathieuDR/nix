{hostname, ...}: {
  imports = [
    ./networks.nix
  ];

  networking.hostName = hostname;
}
