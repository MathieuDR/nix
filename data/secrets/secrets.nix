let
  anchor = builtins.readFile ./agenix-anchor-sytem.pub;
  anchor_thieu = builtins.readFile ./agenix-anchor-thieu.pub;

  system_recipients = [anchor];
  user_recipients = [anchor_thieu];
  # all_recipients = system_recipients ++ user_recipients;
in {
  # network
  "networks.age".publicKeys = system_recipients;

  # common
  "common/gpg.age".publicKeys = user_recipients;
}
