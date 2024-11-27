{
  gaming = import ./gaming.nix;
  programs = {
    onepassword = import ./programs/1password.nix;
    docker = import ./programs/docker.nix;
  };
}
