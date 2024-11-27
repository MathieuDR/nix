{
  nixos = {
    shared = import ./nixos;
    optional = import ./nixos/optional;
  };

  home-manager = {
    shared = import ./home-manager;
    optional = import ./home-manager/optional;
  };
}
