{inputs, ...}: {
  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    packages = {
      highlight-exporter = inputs'.highlight-exporter.packages.default;
      fleeter = inputs'.fleeter.packages.default;
      zeit = import ../pkgs/zeit.nix {inherit pkgs;};
      castersoundboard = import ../pkgs/castersoundboard.nix {inherit pkgs;};
      dungeondraft = import ../pkgs/dungeondraft.nix {inherit pkgs;};
    };
  };
}
