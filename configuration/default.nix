{
  nixos = {
    shared = import ./nixos;
    optional = import ./nixos/optional;
  };
  home-manager = import ./home-manager;
}
