{
  systems = ["x86_64-linux"];

  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages = {
      repl = pkgs.callPackage ./repl {};
      highlight-exporter = inputs'.highlight-exporter.packages.default;
    };
  };
}
