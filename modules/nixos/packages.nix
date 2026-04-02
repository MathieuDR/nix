{...}: {
  flake.modules.nixos.packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      home-manager
      neofetch
      ncdu
      vim
      wget
      git
      htop
    ];
  };
}
