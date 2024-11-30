let
  anchor = builtins.readFile ./id_rsa.pub;
  anchor_thieu = builtins.readFile ./agenix-anchor.pub;
  all_recipients = [anchor anchor_thieu];
in {
  # network
  "networks.age".publicKeys = all_recipients;

  # common
  "common/gpg.age".publicKeys = all_recipients;
}
