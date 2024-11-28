{...}: {
  flake.nixosModules.default = import ./nixos;
  flake.homeManagerModules.default = import ./home-manager;
}
