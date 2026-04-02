# hwdr: Hyprland, Waybar, Dunst, Rofi
# Default desktop environment bundle. Use individual aspects to swap components.
{...}: {
  flake.modules.homeManager.hwdr = {inputs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      hyprland
      waybar
      dunst
      rofi
    ];
  };
}
