{
  systems = ["x86_64-linux"];

  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    packages = {
      highlight-exporter = inputs'.highlight-exporter.packages.default;
      zeit = import ./zeit.nix {inherit pkgs;};
    };
  };
}
