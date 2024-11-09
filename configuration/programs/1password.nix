{
  lib,
  user,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
    ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;

    #TODO: Get user from homemngr
    polkitPolicyOwners = [user];
  };
}
