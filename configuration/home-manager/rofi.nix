{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override {rofi-unwrapped = prev.rofi-wayland-unwrapped;};
    })
    (final: prev: {
      rofimoji = prev.rofimoji.override {rofi = prev.rofi-wayland;};
    })
  ];
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [
      rofi-calc
      # rofimoji
      # rofi-bluetooth
    ];
  };

  home.packages = with pkgs; [
    rofimoji
    rofi-bluetooth
  ];
}
