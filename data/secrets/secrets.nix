let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib;

  base = builtins.readFile ./public_keys/id_rsa.pub;
  anchor = builtins.readFile ./public_keys/agenix-anchor-system.pub;
  anchor_thieu = builtins.readFile ./public_keys/agenix-anchor-thieu.pub;
  wanderer = builtins.readFile ./public_keys/agenix-wanderer-system.pub;
  wanderer_thieu = builtins.readFile ./public_keys/agenix-wanderer-thieu.pub;

  system_recipients = [anchor wanderer];
  user_recipients = [anchor_thieu wanderer_thieu];
  # all_recipients = system_recipients ++ user_recipients;

  withBase = recipients: (lib.lists.unique ([base] ++ recipients));
in {
  # network
  "system/networking.age".publicKeys = withBase system_recipients;

  # common
  "user/gpg.age".publicKeys = withBase user_recipients;
}
