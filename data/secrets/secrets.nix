let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib;

  base = builtins.readFile ./public_keys/id_rsa.pub;
  anchor = builtins.readFile ./public_keys/agenix-anchor-system.pub;
  anchor_thieu = builtins.readFile ./public_keys/agenix-anchor-thieu.pub;

  system_recipients = [anchor base];
  user_recipients = [anchor_thieu base];
  # all_recipients = system_recipients ++ user_recipients;

  withBase = recipients: (lib.lists.unique ([base] ++ recipients));
in {
  # network
  "system/networking.age".publicKeys = withBase system_recipients;

  # common
  "user/gpg.age".publicKeys = withBase user_recipients;
}
