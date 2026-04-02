let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib;

  base = builtins.readFile ./public_keys/id_rsa.pub;
  bastion = builtins.readFile ./public_keys/agenix-bastion-system.pub;
  bastion_thieu = builtins.readFile ./public_keys/agenix-bastion-thieu.pub;

  system_recipients = [bastion];
  user_recipients = [bastion_thieu];

  withBase = recipients: (lib.lists.unique ([base] ++ recipients));
in {
  "system/networking.age".publicKeys = withBase system_recipients;
  "user/gpg.age".publicKeys = withBase user_recipients;
  "shlink/key.age".publicKeys = withBase user_recipients;
}
