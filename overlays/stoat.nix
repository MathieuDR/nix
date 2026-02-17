{inputs}: final: prev: {
  stoat-desktop =
    inputs.nixpkgs-master.legacyPackages.${prev.system}.stoat-desktop;
}
