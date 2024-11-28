{lib, ...}:
with lib; {
  options.ysomic.wayland.hyprland = {
    enable = mkEnableOption "Hyprland";
    hyprlock = {
      enable = mkEnableOption "Hyprlock";
    };
  };
}
