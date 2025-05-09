{
  systems = ["x86_64-linux"];

  perSystem = {inputs', ...}: {
    packages = {
      highlight-exporter = inputs'.highlight-exporter.packages.default;
    };
  };
}
