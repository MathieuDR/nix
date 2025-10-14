{
  inputs,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    # xwayland.enable = true;
  };

  # services.displayManager.sddm.wayland.enable = true;
  # services.xserver.enable = false;

  xdg.portal = {
    enable = true;
    # extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
  };
}
