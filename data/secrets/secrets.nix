let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib;

  base = builtins.readFile ./public_keys/id_rsa.pub;
  anchor = builtins.readFile ./public_keys/agenix-anchor-system.pub;
  anchor_thieu = builtins.readFile ./public_keys/agenix-anchor-thieu.pub;
  bastion = builtins.readFile ./public_keys/agenix-bastion-system.pub;
  bastion_thieu = builtins.readFile ./public_keys/agenix-bastion-thieu.pub;
  imposter = builtins.readFile ./public_keys/agenix-imposter-system.pub;
  imposter_thieu = builtins.readFile ./public_keys/agenix-imposter-thieu.pub;

  system_recipients = [anchor bastion imposter];
  user_recipients = [anchor_thieu bastion_thieu imposter_thieu];

  withBase = recipients: (lib.lists.unique ([base] ++ recipients));
in {
  # network
  "system/networking.age".publicKeys = withBase system_recipients;

  # common
  "user/gpg.age".publicKeys = withBase user_recipients;
}
