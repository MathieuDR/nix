{
  gaming = import ./gaming.nix;
  power-management = import ./power-management.nix;
  wake-up = import ./wake-up.nix;
  programs = {
    onepassword = import ./programs/1password.nix;
    docker = import ./programs/docker.nix;
  };
}
