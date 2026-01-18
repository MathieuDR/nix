{inputs, ...}: {
  systems = ["x86_64-linux"];

  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    packages = {
      highlight-exporter = inputs'.highlight-exporter.packages.default;
      zeit = import ./zeit.nix {inherit pkgs;};
      castersoundboard = import ./castersoundboard.nix {inherit pkgs;};
      dungeondraft = import ./dungeondraft.nix {inherit pkgs;};
    };
  };
}
