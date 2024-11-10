{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    home-manager
    gedit

    neofetch
    ncdu
    vim
    wget
    git
    htop
  ];
}
