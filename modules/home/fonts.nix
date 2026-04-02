{...}: {
  flake.modules.homeManager.fonts = {pkgs, ...}: {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
      roboto
      ubuntu-sans
      ubuntu-classic
    ];
  };
}
