{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      stress-ng
    ];
  };
}
