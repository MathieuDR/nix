{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      # Benchmark
      furmark

      # Stress tests
      stress-ng
    ];
  };
}
